class RemoveUploadFromDoc < ActiveRecord::Migration
  def self.up
    remove_column :doc_heads,:upload_file_name
    remove_column :doc_heads,:upload_content_type
    remove_column :doc_heads,:upload_file_size
    remove_column :doc_heads,:upload_updated_at
  end

  def self.down
  end
end
