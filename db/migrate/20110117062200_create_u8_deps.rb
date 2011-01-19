class CreateU8Deps < ActiveRecord::Migration
  def self.up
    create_table :u8_deps do |t|
      t.string :cdepcode
      t.boolean :bdepend
      t.string :cdepname
      t.string :idepgrade

      t.timestamps
    end
  end

  def self.down
    drop_table :u8_deps
  end
end
