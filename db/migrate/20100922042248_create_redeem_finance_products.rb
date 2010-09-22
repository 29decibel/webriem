class CreateRedeemFinanceProducts < ActiveRecord::Migration
  def self.up
    create_table :redeem_finance_products do |t|
      t.string :name
      t.decimal :rate
      t.integer :account_id
      t.date :clear_date
      t.date :redeem_date
      t.text :description
      t.decimal :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :redeem_finance_products
  end
end
