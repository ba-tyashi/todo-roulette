class CreateTodos < ActiveRecord::Migration[7.2]
  def change
    create_table :todos do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.datetime :deadline
      t.integer :priority, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
