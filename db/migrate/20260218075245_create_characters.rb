class CreateCharacters < ActiveRecord::Migration[7.2]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :image_url
      t.text :description

      t.timestamps
    end
  end
end
