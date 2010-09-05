class CreateLodgings < ActiveRecord::Migration
  def self.up
    create_table :lodgings do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :lodgings
  end
end
