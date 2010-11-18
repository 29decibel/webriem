class ChangeDecimalColumn < ActiveRecord::Migration
  def self.up
    change_column :recivers,:amount,:decimal,        :precision =>16 , :scale => 2
  end

  def self.down
  end
end
