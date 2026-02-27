class AddEvolutionToCharacters < ActiveRecord::Migration[7.0]
  def change
    add_column :characters, :next_character_id, :integer
    add_column :characters, :required_exp, :integer, default: 0
    add_column :characters, :evolution_level: :integer, default: 1
  end
end