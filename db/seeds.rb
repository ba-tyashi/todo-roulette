# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# キャラクターのマスター作成（今のコードを維持）
egg = Character.find_or_create_by!(id: 1) do |c|
  c.name = "はじまりの卵"
  c.description = "ここからすべてが始まる、不思議な卵。"
  c.image_url = "egg_01.png"
end

# カテゴリ作成（今のコードを維持）
['勉強', '運動', '家事', '仕事', '趣味'].each do |name|
  Category.find_or_create_by!(name: name)
end

# ★ここを追加：既存の全ユーザーに「はじまりの卵」を配る
User.all.each do |user|
  # すでにキャラクターを持っている場合はスキップ、持っていない場合のみ追加
  unless user.characters.exists?(egg.id)
    user.characters << egg
    puts "#{user.email} に「#{egg.name}」を配布しました！"
  end
end

puts "初期データの投入とキャラクター配布が完了しました！"