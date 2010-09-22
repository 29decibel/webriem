class CreateRdTravels < ActiveRecord::Migration
  def self.up
    create_table :rd_travels do |t|
      t.integer :sequence
      t.integer :days
      t.integer :region_id
      t.string :reson
      t.integer :fee_standard_id
      t.string :other_fee
      t.string :other_fee_description
      t.decimal :apply_amount
      t.decimal :hr_amount
      t.decimal :fi_amount
      t.decimal :final_amount
      t.integer :reim_detail_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rd_travels
  end
end
