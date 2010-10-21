class AddCodeToPersontype < ActiveRecord::Migration
  def self.up
    add_column :person_types,:code,:string
  end

  def self.down
    remove_column :person_types,:code
  end
end
