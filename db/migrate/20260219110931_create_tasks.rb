class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :title, null: false
      t.integer :priority, default: 1, null: false
      t.boolean :completed, default: false, null: false

      t.timestamps
    end
  end
end
