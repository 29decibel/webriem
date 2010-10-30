class AddPersonTypeToFs < ActiveRecord::Migration
  def self.up
    add_column :fee_standards,:person_type_id,:integer
  end

  def self.down
    remove_column :fee_standards,:person_type_id
  end
end
