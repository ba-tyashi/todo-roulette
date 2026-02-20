class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category

  # 優先度の定義
  # 修正ポイント：Controller側で 'middle' を使っていた場合、ここも 'middle' に合わせる
  enum :priority, { low: 0, medium: 1, high: 2 }

  # ルーレット用の重み（チケット数）を返すメソッド
  def weight
    # self[ :priority ] ではなく enum の文字列判定を利用
    case priority
    when 'high'   then 3
    when 'medium' then 2 # ここを enum の定義と合わせる
    when 'low'    then 1
    else 1 # 0ではなく最低1にすると、ルーレットから消えるバグを防げます
    end
  end

  # 未完了のタスクのみを抽出するスコープ
  scope :incomplete, -> { where(completed: false) }
end
