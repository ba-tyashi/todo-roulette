class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  
  has_many :tasks, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :character_instances, dependent: :destroy

  # 育成中の最新キャラを特定
  def current_character
    character_instances.last
  end

  # 進化チェックロジック（変身版）
  def evolution_check!(last_task_category_id)
    char_inst = current_character
    return false unless char_inst

    # 1. データベースから最新の経験値を確実に読み込む
    char_inst.reload 

    # 2. 経験値がしきい値(5)に達しているかチェック
    if char_inst.experience >= char_inst.character.required_exp
      category = Category.find_by(id: last_task_category_id)
      return false unless category

      # カテゴリー名に基づいて変身先の名前を決定
      target_char_name = case category.name
                         when '勉強' then 'インテリ恐竜'
                         when '運動' then 'マッチョ恐竜'
                         when '家事' then '主婦恐竜'
                         when '仕事' then 'ビジネス恐竜'
                         when '趣味' then 'パリピ恐竜'
                         else 'はじまりの卵'
                         end

      # 3. 変身先のデータを取得
      next_species = Character.find_by(name: target_char_name)

      if next_species
        # 現在と同じ姿でも経験値を0にリセットして「進化演出」を出す
        char_inst.update!(
          character_id: next_species.id,
          experience: 0 
        )
        return true
      end
    end
    false
  end

  after_create :give_first_character

  private

  def give_first_character
    # id: 1 の「はじまりの卵」を初期キャラとして配布
    self.character_instances.create!(character_id: 1)
  rescue => e
    Rails.logger.error "初期キャラクターの配布に失敗しました: #{e.message}"
  end
end