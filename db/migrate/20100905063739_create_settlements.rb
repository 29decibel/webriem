class CreateSettlements < ActiveRecord::Migration
  def self.up
    create_table :settlements do |t|
      t.string :code
      t.string :name
      t.string :subject

      t.timestamps
    end
  end

  def self.down
    drop_table :settlements
  end
end
