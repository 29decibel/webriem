class CreateSystemConfigs < ActiveRecord::Migration
  def self.up
    create_table :system_configs do |t|
      t.string :key
      t.string :value
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :system_configs
  end
end
