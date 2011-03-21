class AddPtypeId < ActiveRecord::Migration
  def self.up
    add_column :fixed_properties,:property_type_id,:integer
  end

  def self.down
  end
end
