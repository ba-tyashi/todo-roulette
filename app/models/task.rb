class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category

  # 優先度の定義
  enum :priority, { low: 0, medium: 1, high: 2 }

  # ルーレット用の重み（チケット数）を返すメソッド
  def weight
    case priority
    when 'high'   then 3
    when 'medium' then 2
    when 'low'    then 1
    else 0
    end
  end

  # 未完了のタスクのみを抽出するスコープ（ルーレット用）
  scope :incomplete, -> { where(completed: false) }
end
