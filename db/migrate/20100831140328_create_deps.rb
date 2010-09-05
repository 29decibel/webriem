class CreateDeps < ActiveRecord::Migration
  def self.up
    create_table :deps do |t|
      t.string :code
      t.string :name
      t.string :version
      t.datetime :start_date
      t.datetime :end_date
      t.string :u8dep_code

      t.timestamps
    end
  end

  def self.down
    drop_table :deps
  end
end
