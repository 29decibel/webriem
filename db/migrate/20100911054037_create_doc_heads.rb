class CreateDocHeads < ActiveRecord::Migration
  def self.up
    create_table :doc_heads do |t|
      t.integer :doc_no
      t.integer :attach
      t.integer :person_id
      t.string :note
      t.date :apply_date
      t.integer :dep_id
      t.integer :fee_id

      t.timestamps
    end
  end

  def self.down
    drop_table :doc_heads
  end
end
