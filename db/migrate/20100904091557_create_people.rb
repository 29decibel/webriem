class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :name
      t.string :code
      t.integer :gender
      t.integer :dep_id
      t.integer :duty_id
      t.integer :boss
      t.string :phone
      t.string :e_mail
      t.string :ID_card
      t.string :bank_no
      t.string :bank
      t.date :end_date
      t.integer :credit_limit

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
