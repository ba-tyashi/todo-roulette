class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      # 送信後はログイン画面へ戻り、メッセージを表示
      redirect_to new_user_session_path, notice: '管理者へ送信しました。対応をお待ちください。'
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:email, :content)
  end
end
