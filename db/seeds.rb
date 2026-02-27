# カテゴリの作成
['勉強', '運動', '家事', '仕事', '趣味'].each do |name|
  Category.find_or_create_by!(name: name)
end

# キャラクターの定義（すべて必要経験値を 5 に統一）
characters_data = [
  { id: 1, name: "はじまりの卵",   image: "egg.png" },
  { id: 2, name: "インテリ恐竜",   image: "intel_dino.png" },   # 勉強
  { id: 3, name: "マッチョ恐竜",   image: "macho_dino.png" },   # 運動
  { id: 4, name: "主婦恐竜",       image: "housework_dino.png" }, # 家事
  { id: 5, name: "ビジネス恐竜",   image: "business_dino.png" }, # 仕事
  { id: 6, name: "パリピ恐竜",     image: "party_dino.png" }    # 趣味
]

characters_data.each do |data|
  Character.find_or_create_by!(id: data[:id]) do |c|
    c.name = data[:name]
    c.required_exp = 5  # ここを 5 にすることで 5回で進化
    c.image_url = data[:image]
  end
end

puts "Seed loaded: 5回で進化する設定を反映しました。"