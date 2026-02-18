class CreateCharacterInstances < ActiveRecord::Migration[7.2]
  def change
    create_table :character_instances do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :character_id

      t.timestamps
    end
  end
end
