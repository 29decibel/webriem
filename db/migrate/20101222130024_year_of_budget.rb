class YearOfBudget < ActiveRecord::Migration
  def self.up
    add_column :budgets,:year,:integer
  end

  def self.down
  end
end
