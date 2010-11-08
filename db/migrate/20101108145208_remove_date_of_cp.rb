class RemoveDateOfCp < ActiveRecord::Migration
  def self.up
    remove_column :cp_doc_details,:apply_date
  end

  def self.down
  end
end
