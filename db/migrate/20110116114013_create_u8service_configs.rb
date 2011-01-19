class CreateU8serviceConfigs < ActiveRecord::Migration
  def self.up
    create_table :u8service_configs do |t|
      t.string :dbname
      t.string :username
      t.string :password
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :u8service_configs
  end
end
