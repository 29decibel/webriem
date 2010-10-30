class CreateExtraWorkStandards < ActiveRecord::Migration
  def self.up
    create_table :extra_work_standards do |t|
      t.integer :larger_than_hours
      t.integer :late_than_time
      t.boolean :is_sunday,:default=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :extra_work_standards
  end
end
