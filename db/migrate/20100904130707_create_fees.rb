class CreateFees < ActiveRecord::Migration
  def self.up
    create_table :fees do |t|
      t.string :code
      t.string :name
      t.integer :attr
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :fees
  end
end
