class CreateFixedProperties < ActiveRecord::Migration
  def self.up
    create_table :fixed_properties do |t|
      t.string :type
      t.string :name
      t.string :code
      t.string :sequence
      t.decimal :buy_unit,         :precision => 16, :scale => 2
      t.integer :buy_count
      t.decimal :original_value,         :precision => 16, :scale => 2
      t.integer :keeper_id
      t.string :place
      t.integer :afford_dep_id
      t.integer :project_id
      t.integer :doc_head_id

      t.timestamps
    end
  end

  def self.down
    drop_table :fixed_properties
  end
end
