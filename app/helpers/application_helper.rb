module ApplicationHelper
  def string_to_color(str)
    # .abs を追加して、必ず 0〜359 の正の数にする
    "hsl(#{str.hash.abs % 360}, 70%, 60%)"
  end
end
