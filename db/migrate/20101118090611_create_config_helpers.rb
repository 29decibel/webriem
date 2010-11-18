class CreateConfigHelpers < ActiveRecord::Migration
  def self.up
    create_table :config_helpers do |t|
      t.string :key
      t.string :value

      t.timestamps
    end
  end

  def self.down
    drop_table :config_helpers
  end
end
