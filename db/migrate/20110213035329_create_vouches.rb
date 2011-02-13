class CreateVouches < ActiveRecord::Migration
  def self.up
    create_table :vouches do |t|
      t.string :ino_id
      t.string :inid
      t.string :dbill_date
      t.string :idoc
      t.string :cbill
      t.string :doc_no
      t.string :ccode
      t.string :cexch_name
      t.string :md
      t.string :mc
      t.string :md_f
      t.string :mc_f
      t.string :nfrat
      t.string :cdept_id
      t.string :cperson_id
      t.string :citem_id
      t.string :ccode_equal

      t.timestamps
    end
  end

  def self.down
    drop_table :vouches
  end
end
