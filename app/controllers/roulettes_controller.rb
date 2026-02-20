class RoulettesController < ApplicationController
  def show
    # モデルで定義した incomplete スコープを活用
    @tasks = current_user.tasks.incomplete.map do |task|
      {
        id: task.id,
        title: task.title,
        color: view_context.string_to_color(task.title),
        # モデルの weight メソッドを使用して重みを取得
        weight: task.weight
      }
    end
  end

  def spin
    tasks = current_user.tasks.incomplete
    
    if tasks.empty?
      render json: { error: "タスクがありません" }, status: :unprocessable_entity
      return
    end

    # --- 厳正な重み付け抽選ロジック ---
    total_weight = tasks.sum(&:weight)
    random_point = rand(total_weight) # 0 〜 合計重みの間で乱数を生成
    
    winning_task = nil
    accumulator = 0
    
    tasks.each do |task|
      accumulator += task.weight
      if random_point < accumulator
        winning_task = task
        break
      end
    end
    # ------------------------------

    # JS側で5回転（1800度）させる演出は、JS側で制御したほうが柔軟なため
    # ここでは当選したタスクの情報のみを返却します
    render json: { task: winning_task }
  end
end
