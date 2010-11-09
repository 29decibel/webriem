class CreateOtherRiems < ActiveRecord::Migration
  def self.up
    create_table :other_riems do |t|
      t.integer :sequence
      t.string :description
      t.integer :currency_id
      t.decimal :rate,      :precision => 8, :scale => 2
      t.integer :doc_head_id
      t.decimal :ori_amount,      :precision => 8, :scale => 2
      t.decimal :apply_amount,      :precision => 8, :scale => 2
      t.decimal :hr_amount,      :precision => 8, :scale => 2
      t.decimal :fi_amount,      :precision => 8, :scale => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :other_riems
  end
end
