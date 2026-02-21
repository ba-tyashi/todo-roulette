class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # バリデーション
  validates :name, presence: true
  
  # ↓ここを削除（または # でコメントアウト）
  # validates :email, uniqueness: { message: "は使用できません。" } 
  # ※Deviseのvalidatableが自動でチェックしてくれるので不要です。

  # 関連付け
  has_many :tasks, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :character_instances, dependent: :destroy

  # コールバック：ユーザー登録完了直後に初期キャラを配布
  after_create :give_first_character

  private

  def give_first_character
    self.character_instances.create!(character_id: 1)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "初期キャラクターの配布に失敗しました: #{e.message}"
  end
end
