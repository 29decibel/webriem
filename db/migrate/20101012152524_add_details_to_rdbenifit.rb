class AddDetailsToRdbenifit < ActiveRecord::Migration
  def self.up
    add_column :rd_benefits, :details_file_name,    :string
    add_column :rd_benefits, :details_content_type, :string
    add_column :rd_benefits, :details_file_size,    :integer
    add_column :rd_benefits, :details_updated_at,   :datetime
  end

  def self.down
    remove_column :rd_benefits, :details_file_name
    remove_column :rd_benefits, :details_content_type
    remove_column :rd_benefits, :details_file_size
    remove_column :rd_benefits, :details_updated_at
  end
end
