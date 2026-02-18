class CharacterInstance < ApplicationRecord
  belongs_to :user
  belongs_to :character

  # ユーザーIDとキャラクターIDは必須
  validates :user_id, presence: true
  validates :character_id, presence: true
end
