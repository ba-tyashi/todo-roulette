class UsersController < ApplicationController
  # ログインしていないと見れないようにする
  before_action :authenticate_user!

  def show
    @user = current_user
    # ユーザーが持っている「卵」などのインスタンスを、マスターデータ(character)と一緒に取得
    @character_instances = @user.character_instances.includes(:character)
  end
end
