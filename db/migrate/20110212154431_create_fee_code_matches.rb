class CreateFeeCodeMatches < ActiveRecord::Migration
  def self.up
    create_table :fee_code_matches do |t|
      t.integer :fee_id
      t.integer :dcode_id
      t.integer :ccode_id
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :fee_code_matches
  end
end
