class CreateBudgets < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
      t.integer :fee_id
      t.integer :project_id
      t.integer :dep_id
      t.decimal :jan
      t.decimal :feb
      t.decimal :mar
      t.decimal :apr
      t.decimal :may
      t.decimal :jun
      t.decimal :jul
      t.decimal :aug
      t.decimal :sep
      t.decimal :oct
      t.decimal :nov
      t.decimal :dec

      t.timestamps
    end
  end

  def self.down
    drop_table :budgets
  end
end
