class AddUploadIdToRdbeni < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:upload_file_id,:integer
    remove_column :rd_benefits,:details_file_name
    remove_column :rd_benefits,:details_content_type
    remove_column :rd_benefits,:details_file_size
    remove_column :rd_benefits,:details_updated_at
    add_column :rd_benefits,:dep_id,:integer
    add_column :rd_benefits,:fee_id,:integer
  end

  def self.down
  end
end
