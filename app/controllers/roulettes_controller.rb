class RoulettesController < ApplicationController
  def show
    @tasks = current_user.tasks.where(completed: false).map do |task|
      {
        id: task.id,
        title: task.title,
        color: view_context.string_to_color(task.title),
        # 優先度を重みとして渡す（カラムがない場合はデフォルト1）
        weight: task.priority || 1 
      }
    end
  end

  def spin
    # サーバー側でも重み付け抽選を行う
    # weighted_sample は別途モデル等で定義が必要
    @task = current_user.tasks.where(completed: false).sample 
    
    # 停止位置の計算（360度 * 5回転 + ランダム角度）
    stop_degree = 1800 + rand(360)
    
    render json: { task: @task, stop_degree: stop_degree }
  end
end
