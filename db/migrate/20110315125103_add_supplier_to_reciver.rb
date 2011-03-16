class AddSupplierToReciver < ActiveRecord::Migration
  def self.up
    add_column :recivers,:supplier_id,:integer
  end

  def self.down
  end
end
