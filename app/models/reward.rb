class Reward < ApplicationRecord
  belongs_to :user
  validates :name, presence: true

  # ユーザーのご褒美からランダムに一つ選ぶ
  def self.pick_for(user)
    where(user: user).sample
  end
end
