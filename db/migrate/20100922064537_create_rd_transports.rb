class CreateRdTransports < ActiveRecord::Migration
  def self.up
    create_table :rd_transports do |t|
      t.integer :sequence
      t.integer :reim_detail_id
      t.time :start_date
      t.time :end_date
      t.string :start_position
      t.string :end_position
      t.integer :transportation_id
      t.string :reason
      t.decimal :apply_amount
      t.decimal :hr_amount
      t.decimal :fi_amount
      t.decimal :final_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :rd_transports
  end
end
