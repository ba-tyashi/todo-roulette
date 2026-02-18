# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Character.find_or_create_by!(id: 1) do |c|
  c.name = "はじまりの卵"
  c.description = "ここからすべてが始まる、不思議な卵。"
  # 後ほど画像を追加する際のファイル名
  c.image_url = "egg_01.png"
end

puts "初期キャラクターの作成が完了しました！"
