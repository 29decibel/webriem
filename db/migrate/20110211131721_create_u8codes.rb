class CreateU8codes < ActiveRecord::Migration
  def self.up
    create_table :u8codes do |t|
      t.string :cclass
      t.string :ccode
      t.string :ccode_name
      t.string :igrade
      t.boolean :bend
      t.string :cexch_name
      t.boolean :bperson
      t.boolean :bitem
      t.boolean :bdept

      t.timestamps
    end
  end

  def self.down
    drop_table :u8codes
  end
end
