class RemoveDirectionOfReciver < ActiveRecord::Migration
  def self.up
    remove_column :recivers,:direction
  end

  def self.down
  end
end
