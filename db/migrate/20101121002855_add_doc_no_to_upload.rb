class AddDocNoToUpload < ActiveRecord::Migration
  def self.up
    add_column :upload_files,:doc_no,:string
  end

  def self.down
  end
end
