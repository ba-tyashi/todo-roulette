# --- カテゴリの定義 ---
# カテゴリIDは自動採番に任せますが、あとで名前で検索できるようにします
['勉強', '運動', '家事', '仕事', '趣味'].each do |name|
  Category.find_or_create_by!(name: name)
end

# --- キャラクターの定義 ---
# キャラクターIDは 1〜6 で固定
Character.find_or_create_by!(id: 1, name: "はじまりの卵",   required_exp: 5)
Character.find_or_create_by!(id: 2, name: "ビジネス恐竜",   required_exp: 10) # 仕事
Character.find_or_create_by!(id: 3, name: "主婦恐竜",       required_exp: 10) # 家事
Character.find_or_create_by!(id: 4, name: "マッチョ恐竜",   required_exp: 10) # 運動
Character.find_or_create_by!(id: 5, name: "インテリ恐竜",   required_exp: 10) # 勉強
Character.find_or_create_by!(id: 6, name: "パリピ恐竜",     required_exp: 10) # 趣味