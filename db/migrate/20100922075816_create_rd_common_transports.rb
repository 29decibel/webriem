class CreateRdCommonTransports < ActiveRecord::Migration
  def self.up
    create_table :rd_common_transports do |t|
      t.string :note
      t.string :start_place
      t.string :end_place
      t.integer :sequence
      t.date :work_date
      t.time :start_time
      t.time :end_time
      t.string :reason
      t.integer :reim_detail_id
      t.decimal :apply_amount
      t.decimal :hr_amount
      t.decimal :fi_amount
      t.decimal :final_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :rd_common_transports
  end
end