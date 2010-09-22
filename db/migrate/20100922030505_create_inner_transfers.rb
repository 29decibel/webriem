class CreateInnerTransfers < ActiveRecord::Migration
  def self.up
    create_table :inner_transfers do |t|
      t.integer :out_account
      t.decimal :out_amount_before
      t.decimal :in_amount_before
      t.decimal :amount
      t.text :description
      t.integer :doc_head_id

      t.timestamps
    end
  end

  def self.down
    drop_table :inner_transfers
  end
end
