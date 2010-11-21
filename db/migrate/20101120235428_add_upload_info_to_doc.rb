class AddUploadInfoToDoc < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:upload_file_name,:string
    add_column :doc_heads,:upload_content_type,:string
    add_column :doc_heads,:upload_file_size,:integer
    add_column :doc_heads,:upload_updated_at,:datetime
  end

  def self.down
  end
end
