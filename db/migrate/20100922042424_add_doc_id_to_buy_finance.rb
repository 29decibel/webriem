class AddDocIdToBuyFinance < ActiveRecord::Migration
  def self.up
    add_column :buy_finance_products,:doc_head_id,:integer
    add_column :redeem_finance_products,:doc_head_id,:integer
  end

  def self.down
    remove_column :buy_finance_products,:doc_head_id
    remove_column :redeem_finance_products,:doc_head_id
  end
end
