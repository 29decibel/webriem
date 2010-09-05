class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.integer :busitype
      t.integer :fee_id
      t.integer :dep_id
      t.string :u8_fee_subject
      t.string :u8_borrow_subject
      t.string :u8_reim_subject

      t.timestamps
    end
  end

  def self.down
    drop_table :subjects
  end
end
