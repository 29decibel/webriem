class AddVouchinfoToFcm < ActiveRecord::Migration
  def self.up
    #add debit person and credit person
    #add debit dep and credit dep
    add_column :fee_code_matches,:dperson,:string
    add_column :fee_code_matches,:ddep,:string
    add_column :fee_code_matches,:cperson,:string
    add_column :fee_code_matches,:cdep,:string
  end

  def self.down
  end
end
