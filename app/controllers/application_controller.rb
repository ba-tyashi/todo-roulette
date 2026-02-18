class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # 新規登録(sign_up)の時に name を許可する
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # アカウント更新(account_update)の時も必要なら追加
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
