class CreateReimSplitDetails < ActiveRecord::Migration
  def self.up
    create_table :reim_split_details do |t|
      t.integer :reim_detail_id
      t.integer :dep_id
      t.integer :project_id
      t.integer :fee_id
      t.decimal :percent

      t.timestamps
    end
  end

  def self.down
    drop_table :reim_split_details
  end
end
