class AddMarkToDocHead < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:mark,:string
  end

  def self.down
  end
end
