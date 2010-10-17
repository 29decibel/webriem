class CreateRegionTypes < ActiveRecord::Migration
  def self.up
    create_table :region_types do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :region_types
  end
end
