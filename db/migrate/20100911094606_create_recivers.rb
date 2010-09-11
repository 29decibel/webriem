class CreateRecivers < ActiveRecord::Migration
  def self.up
    create_table :recivers do |t|
      t.integer :sequence
      t.integer :settlement_id
      t.string :company
      t.string :bank
      t.string :bank_no
      t.decimal :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :recivers
  end
end
