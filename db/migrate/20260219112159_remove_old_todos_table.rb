class RemoveOldTodosTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :todos if table_exists?(:todos)
  end
end
