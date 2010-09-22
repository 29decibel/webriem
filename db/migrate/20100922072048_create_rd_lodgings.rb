class CreateRdLodgings < ActiveRecord::Migration
  def self.up
    create_table :rd_lodgings do |t|
      t.integer :sequence
      t.integer :reim_detail_id
      t.integer :region_id
      t.date :lodging_date
      t.integer :days
      t.integer :people_count
      t.string :person_names
      t.decimal :apply_amount
      t.decimal :hr_amount
      t.decimal :fi_amount
      t.decimal :final_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :rd_lodgings
  end
end
