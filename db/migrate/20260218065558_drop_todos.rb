class DropTodos < ActiveRecord::Migration[7.2]
  def change
    if table_exists?(:todos)
      drop_table :todos
    end
  end
end
