class CreateCommonRiems < ActiveRecord::Migration
  def self.up
    create_table :common_riems do |t|
      t.integer :sequence
      t.integer :fee_id
      t.integer :dep_id
      t.integer :project_id
      t.string :description
      t.integer :currency_id
      t.decimal  :apply_amount, :precision => 8, :scale => 2
      t.decimal  :hr_amount,    :precision => 8, :scale => 2
      t.decimal  :fi_amount,    :precision => 8, :scale => 2
      t.decimal  :rate,         :precision => 8, :scale => 2
      t.decimal  :ori_amount,   :precision => 8, :scale => 2
      t.integer :doc_head_id

      t.timestamps
    end
  end

  def self.down
    drop_table :common_riems
  end
end
