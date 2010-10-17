class AddRegiontypeToRegion < ActiveRecord::Migration
  def self.up
    add_column :regions,:region_type_id,:integer
  end

  def self.down
    remove_column :regions,:region_type_id
  end
end
