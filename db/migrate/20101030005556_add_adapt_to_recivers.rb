class AddAdaptToRecivers < ActiveRecord::Migration
  def self.up
    add_column :recivers,  :hr_amount,    :decimal,:precision => 8, :scale => 2
    add_column :recivers,  :fi_amount,    :decimal,:precision => 8, :scale => 2
  end

  def self.down
    remove_column :recivers,  :hr_amount
    remove_column :recivers,  :fi_amount
  end
end
