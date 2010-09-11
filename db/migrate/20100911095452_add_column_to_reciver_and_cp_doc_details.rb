class AddColumnToReciverAndCpDocDetails < ActiveRecord::Migration
  def self.up
    add_column :recivers,:doc_head_id,:integer
    add_column :cp_doc_details,:doc_head_id,:integer
  end

  def self.down
    remove_column :recivers,:doc_head_id
    remove_column :cp_doc_details,:doc_head_id
  end
end
