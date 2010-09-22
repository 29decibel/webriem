class CreateInnerRemittances < ActiveRecord::Migration
  def self.up
    create_table :inner_remittances do |t|
      t.integer :out_account
      t.string :in_account_name
      t.string :in_account_no
      t.decimal :amount
      t.text :description
      t.decimal :remain_amount
      t.decimal :now_rate_price
      t.integer :doc_head_id

      t.timestamps
    end
  end

  def self.down
    drop_table :inner_remittances
  end
end
