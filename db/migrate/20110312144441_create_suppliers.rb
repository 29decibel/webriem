class CreateSuppliers < ActiveRecord::Migration
  def self.up
    create_table :suppliers do |t|
      t.string :name
      t.string :code
      t.string :bank
      t.string :bank_no

      t.timestamps
    end
  end

  def self.down
    drop_table :suppliers
  end
end
