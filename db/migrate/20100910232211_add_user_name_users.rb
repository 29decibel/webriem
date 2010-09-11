class AddUserNameUsers < ActiveRecord::Migration
  def self.up
    add_column :users,:user_name,:string
    add_index :users, :user_name,:unique => true
  end

  def self.down
    remove_column :users,:user_name
    remove_index :users,:user_name
  end
end
