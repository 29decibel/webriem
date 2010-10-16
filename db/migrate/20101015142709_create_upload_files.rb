class CreateUploadFiles < ActiveRecord::Migration
  def self.up
    create_table :upload_files do |t|
      t.integer :p_id

      t.timestamps
    end
  end

  def self.down
    drop_table :upload_files
  end
end
