class CreateRdWorkMeals < ActiveRecord::Migration
  def self.up
    create_table :rd_work_meals do |t|
      t.integer :sequence
      t.date :meal_date
      t.string :place
      t.integer :people_count
      t.string :person_names
      t.string :reason
      t.integer :reim_detail_id
      t.decimal :apply_amount
      t.decimal :hr_amount
      t.decimal :fi_amount
      t.decimal :final_amount

      t.timestamps
    end
  end

  def self.down
    drop_table :rd_work_meals
  end
end
