class RewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rewards = current_user.rewards.order(created_at: :desc)
    @reward = Reward.new
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
    @reward = current_user.rewards.find(params[:id])
    @reward.destroy
    redirect_to rewards_path, notice: "ご褒美を削除しました。", status: :see_other
  end

  private

  def reward_params
    params.require(:reward).permit(:name, :description)
  end
end
