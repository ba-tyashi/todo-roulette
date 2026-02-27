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
    # JavaScript側のチェックボックス操作などにより completed: "true" が送られてきた場合
    if params[:task] && params[:task][:completed].to_s == "true"
      
      # 1. 削除前にカテゴリーIDを一時保存（進化先の判定に使用）
      last_category_id = @task.category_id

      # 2. キャラクターの経験値加算と進化（変身）ロジック
      char_inst = current_user.current_character
      evolved = false

      if char_inst
        # 重みに関わらず 1 加算（5回完了で 5 経験値にするため）
        char_inst.increment!(:experience, 1)
        
        # Userモデルの進化チェックを呼び出し（内部で reload を行う修正版）
        evolved = current_user.evolution_check!(last_category_id)
      end

      # 3. タスクをデータベースから削除
      @task.destroy
      
      # 4. ご褒美データの抽選
      @reward = current_user.rewards.sample
      
      if @reward.present?
        # evolved が true なら姿が変わった旨を通知
        notice_msg = evolved ? "✨ キャラクターの姿が変わった！ ✨" : "タスク完了！経験値を獲得しました。"
        # ご褒美詳細画面へリダイレクト。evolved パラメータを渡し、画面演出に使用可能にする
        redirect_to reward_path(@reward, evolved: evolved), notice: notice_msg, status: :see_other
      else
        # ご褒美が登録されていない場合のフォールバック
        msg = evolved ? "キャラクターが新しい姿になりました！" : "お疲れ様！次はご褒美を登録してみましょう。"
        redirect_to root_path, notice: msg, status: :see_other
      end

    else
      # タイトル編集など、完了以外の通常の更新処理
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
    # ストロングパラメータ
    params.require(:task).permit(:title, :completed, :priority, :category_id, :weight, :color)
  end
end
