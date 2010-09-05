class CreateFeeStandards < ActiveRecord::Migration
  def self.up
    create_table :fee_standards do |t|
      t.integer :project_id
      t.integer :region_id
      t.integer :duty_id
      t.integer :lodging_id
      t.integer :transportation_id
      t.integer :type
      t.decimal :amount

      t.timestamps
    end
  end

  def self.down
    drop_table :fee_standards
  end
end
