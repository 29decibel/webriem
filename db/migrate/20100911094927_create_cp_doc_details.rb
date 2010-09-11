class CreateCpDocDetails < ActiveRecord::Migration
  def self.up
    create_table :cp_doc_details do |t|
      t.integer :sequence
      t.date :apply_date
      t.integer :dep_id
      t.integer :fee_id
      t.integer :project_id
      t.string :used_for
      t.integer :currency_id
      t.decimal :apply_amount
      t.decimal :ori_amount
      t.decimal :rate

      t.timestamps
    end
  end

  def self.down
    drop_table :cp_doc_details
  end
end
