class AddDocHeadIdToVouch < ActiveRecord::Migration
  def self.up
    add_column :vouches,:doc_head_id,:integer
  end

  def self.down
  end
end
