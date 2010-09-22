class CreateInnerCashDraws < ActiveRecord::Migration
  def self.up
    create_table :inner_cash_draws do |t|
      t.integer :account_id
      t.decimal :now_remain_amout
      t.text :description
      t.integer :doc_head_id

      t.timestamps
    end
  end

  def self.down
    drop_table :inner_cash_draws
  end
end
