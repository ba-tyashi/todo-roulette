class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  has_many :character_instances, dependent: :destroy

  # ユーザー登録が完了した直後に give_first_character メソッドを実行する
  after_create :give_first_character
  has_many :tasks, dependent: :destroy

  private

  def give_first_character
    # キャラクターID「1」を初期配布
    # create! を使うことで、失敗した時にエラーを出して気づけるようにします
    self.character_instances.create!(character_id: 1)
  end
end
