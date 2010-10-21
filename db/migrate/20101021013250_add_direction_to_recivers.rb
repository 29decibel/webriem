class AddDirectionToRecivers < ActiveRecord::Migration
  def self.up
    add_column :recivers,:direction,:integer
  end

  def self.down
    remove_column :recivers,:direction
  end
end
