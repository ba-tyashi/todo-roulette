class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[ show edit update destroy ]

  def index
    @tasks = current_user.tasks.includes(:category).order(created_at: :desc)
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)

    respond_to do |format|
      if @task.save
        format.turbo_stream # create.turbo_stream.erb を探しにいく
        format.html { redirect_to tasks_path, notice: "タスクを追加しました！" }
      else
        @tasks = current_user.tasks.includes(:category).order(created_at: :desc)
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task.destroy!
    respond_to do |format|
      format.turbo_stream # destroy.turbo_stream.erb を探しにいく
      format.html { redirect_to tasks_path, notice: "削除しました", status: :see_other }
    end
  end

  # show, edit, update は空のまま下へ
  def show
    redirect_to tasks_path
  end

  def edit; end
  def update
    respond_to do |format|
      if @task.update(task_params)
        # タスクが完了になった時だけ、ご褒美を抽選する
        @reward = Reward.pick_for(current_user) if @task.completed?

        format.turbo_stream
        format.html { redirect_to tasks_path, notice: "更新しました" }
      else
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :category_id, :priority, :completed)
  end
end
