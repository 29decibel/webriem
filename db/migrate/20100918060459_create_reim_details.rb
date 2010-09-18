class CreateReimDetails < ActiveRecord::Migration
  def self.up
    create_table :reim_details do |t|
      t.integer :sequence
      t.integer :fee_id
      t.integer :dep_id
      t.integer :project_id
      t.string :description
      t.decimal :amount
      t.integer :currency_id
      t.decimal :ori_amount
      t.decimal :rate
      t.decimal :real_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :reim_details
  end
end
