class CreateCashDrawItems < ActiveRecord::Migration
  def self.up
    create_table :cash_draw_items do |t|
      t.integer :sequence
      t.string :used_for
      t.decimal :apply_amount
      t.integer :inner_cash_draw_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cash_draw_items
  end
end
