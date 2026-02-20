class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[ edit update destroy ]

  def index
    @tasks = current_user.tasks.all
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    
    respond_to do |format|
      if @task.save
        format.turbo_stream
        format.html { redirect_to root_path, notice: "タスクを作成しました" }
      else
        @tasks = current_user.tasks.all
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def update
    # JavaScriptから completed: "true" が送られてきたら物理削除する
    if params[:task] && params[:task][:completed].to_s == "true"
      @task.destroy
      
      # 1. ユーザーのご褒美から抽選
      @reward = current_user.rewards.sample
      
      if @reward.present?
        # データがあれば、そのご褒美の詳細画面へ
        redirect_to reward_path(@reward), status: :see_other
      else
        # データがない場合は、エラーにせずトップへ戻る（またはメッセージを出す）
        redirect_to root_path, notice: "お疲れ様！ご褒美を登録するとここに表示されますよ。", status: :see_other
      end
    else
      # 通常の編集処理（ここは変更なし）
      if @task.update(task_params)
        redirect_to root_path, notice: "タスクを更新しました"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@task) }
      format.html { redirect_to root_path, notice: "タスクを削除しました", status: :see_other }
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "タスクが見つかりませんでした"
  end

  def task_params
    params.require(:task).permit(:title, :completed, :priority, :category_id, :weight, :color)
  end
end