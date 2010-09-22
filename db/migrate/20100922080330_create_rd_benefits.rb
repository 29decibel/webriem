class CreateRdBenefits < ActiveRecord::Migration
  def self.up
    create_table :rd_benefits do |t|
      t.integer :sequence
      t.date :reim_date
      t.integer :fee_time_span
      t.integer :fee_id
      t.integer :dep_id
      t.integer :people_count
      t.decimal :amount
      t.integer :reim_detail_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rd_benefits
  end
end
