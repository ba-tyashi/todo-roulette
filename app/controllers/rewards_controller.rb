class RewardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reward, only: [:show, :destroy] # showを追加

  def index
    @rewards = current_user.rewards.order(created_at: :desc)
    @reward = Reward.new
  end

  # この show アクションがないと /rewards/:id にアクセスできません
  def show
  end

  def create
    @reward = current_user.rewards.build(reward_params)
    if @reward.save
      redirect_to rewards_path, notice: "ご褒美を追加しました！"
    else
      @rewards = current_user.rewards.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @reward.destroy
    redirect_to rewards_path, notice: "ご褒美を削除しました。", status: :see_other
  end

  private

  def set_reward
    @reward = current_user.rewards.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to rewards_path, alert: "ご褒美が見つかりませんでした"
  end

  def reward_params
    params.require(:reward).permit(:name, :description)
  end
end