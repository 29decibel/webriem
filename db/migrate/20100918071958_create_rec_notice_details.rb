class CreateRecNoticeDetails < ActiveRecord::Migration
  def self.up
    create_table :rec_notice_details do |t|
      t.integer :sequence
      t.date :apply_date
      t.string :company
      t.integer :dep_id
      t.integer :project_id
      t.string :description
      t.decimal :amount
      t.integer :currency_id
      t.decimal :ori_amount
      t.decimal :rate
      t.integer :doc_head_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rec_notice_details
  end
end
