class CreateDuties < ActiveRecord::Migration
  def self.up
    create_table :duties do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end

  def self.down
    drop_table :duties
  end
end
