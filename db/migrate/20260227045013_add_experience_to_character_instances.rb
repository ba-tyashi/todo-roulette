# db/migrate/xxx_add_experience_to_character_instances.rb
class AddExperienceToCharacterInstances < ActiveRecord::Migration[7.0]
  def change
    add_column :character_instances, :experience, :integer, default: 0
  end
end
