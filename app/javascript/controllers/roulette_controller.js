import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "result", "button"]
  static values = { tasks: Array }

  connect() {
    this.currentRotation = 0;
    this.selectedTaskId = null;
    setTimeout(() => { this.refreshRoulette(); }, 300);
  }

  tasksValueChanged() {
    this.refreshRoulette();
  }

  refreshRoulette() {
    const canvas = this.hasCanvasTarget ? this.canvasTarget : null;
    if (!canvas) return;

    const ctx = canvas.getContext("2d");
    const tasks = Array.isArray(this.tasksValue) ? this.tasksValue : [];
    
    canvas.width = 400;
    canvas.height = 400;
    ctx.clearRect(0, 0, 400, 400);

    if (tasks.length === 0) {
      ctx.beginPath();
      ctx.arc(200, 200, 180, 0, Math.PI * 2);
      ctx.fillStyle = "#eeeeee";
      ctx.fill();
      ctx.fillStyle = "#999999";
      ctx.font = "20px sans-serif";
      ctx.textAlign = "center";
      ctx.fillText("タスクがありません", 200, 205);
      return;
    }

    const totalWeight = tasks.reduce((sum, t) => sum + (Number(t.weight) || 1), 0);
    let currentAngle = -Math.PI / 2;

    tasks.forEach((task, i) => {
      const weight = Number(task.weight) || 1;
      const segmentAngle = (weight / totalWeight) * Math.PI * 2;
      
      ctx.beginPath();
      ctx.fillStyle = task.color || `hsl(${i * (360 / tasks.length)}, 70%, 60%)`;
      ctx.moveTo(200, 200);
      ctx.arc(200, 200, 195, currentAngle, currentAngle + segmentAngle);
      ctx.fill();
      ctx.strokeStyle = "#ffffff";
      ctx.lineWidth = 2;
      ctx.stroke();

      ctx.save();
      ctx.translate(200, 200);
      const middleAngle = currentAngle + segmentAngle / 2;
      ctx.rotate(middleAngle + Math.PI / 2);
      ctx.textAlign = "center";
      ctx.textBaseline = "bottom";
      ctx.fillStyle = "#ffffff";
      ctx.font = "bold 18px sans-serif";
      ctx.fillText(task.title ? task.title.substring(0, 8) : "Task", 0, -145); 
      ctx.restore();

      currentAngle += segmentAngle;
    });
  }

  async spin() {
    if (this.buttonTarget.disabled) return;
    this.buttonTarget.disabled = true;
    this.resultTarget.classList.add("hidden");

    try {
      const response = await fetch("/roulette/spin", {
        method: "POST",
        headers: { 
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken,
          "X-Requested-With": "XMLHttpRequest"
        }
      });
      const data = await response.json();
      this.selectedTaskId = data.task.id;

      const tasks = this.tasksValue;
      const totalWeight = tasks.reduce((sum, t) => sum + (Number(t.weight) || 1), 0);
      let accumulatedWeight = 0;
      let targetIndex = tasks.findIndex(t => t.id === data.task.id);
      
      for (let i = 0; i < targetIndex; i++) {
        accumulatedWeight += (Number(tasks[i].weight) || 1);
      }
      
      const targetWeight = (Number(tasks[targetIndex].weight) || 1);
      const centerPosInDegrees = (accumulatedWeight + targetWeight / 2) / totalWeight * 360;
      const rotationToTarget = 360 - centerPosInDegrees;
      this.currentRotation += (1800 + rotationToTarget + (360 - (this.currentRotation % 360)));

      this.canvasTarget.style.transform = `rotate(${this.currentRotation}deg)`;

      setTimeout(() => {
        document.getElementById("winnerName").textContent = data.task.title;
        this.resultTarget.classList.remove("hidden");
        this.buttonTarget.disabled = false;
      }, 5000);
    } catch (e) {
      console.error("Spin error:", e);
      this.buttonTarget.disabled = false;
    }
  }

  async complete() {
    if (!this.selectedTaskId) return;

    try {
      const response = await fetch(`/tasks/${this.selectedTaskId}`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfToken,
          "X-Requested-With": "XMLHttpRequest",
          "Accept": "text/html"
        },
        // Rails側で判定しやすいよう文字列で送る
        body: JSON.stringify({ task: { completed: "true" } })
      });

      // サーバーからのリダイレクト指示に従う
      if (response.redirected) {
        window.location.href = response.url;
      } else if (response.url) {
        window.location.assign(response.url);
      }
    } catch (e) {
      console.error("Complete error:", e);
    }
  }

  get csrfToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content || "";
  }
}
