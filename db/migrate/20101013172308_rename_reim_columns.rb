class RenameReimColumns < ActiveRecord::Migration
  def self.up
    rename_column :rd_travels,:reim_detail_id,:doc_head_id
    rename_column :rd_transports,:reim_detail_id,:doc_head_id
    rename_column :rd_lodgings,:reim_detail_id,:doc_head_id
    rename_column :rd_work_meals,:reim_detail_id,:doc_head_id
    rename_column :rd_extra_work_cars,:reim_detail_id,:doc_head_id
    rename_column :rd_extra_work_meals,:reim_detail_id,:doc_head_id
    rename_column :rd_benefits,:reim_detail_id,:doc_head_id
    rename_column :rd_common_transports,:reim_detail_id,:doc_head_id
    rename_column :reim_split_details,:reim_detail_id,:doc_head_id
  end

  def self.down
  end
end
