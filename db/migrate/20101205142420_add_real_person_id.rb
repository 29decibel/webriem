class AddRealPersonId < ActiveRecord::Migration
  def self.up
    add_column :doc_heads,:real_person_id,:integer
  end

  def self.down
  end
end
