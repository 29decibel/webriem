class AddIndexToAllModel < ActiveRecord::Migration
  def self.up
    add_index :budgets,:fee_id
    add_index :budgets,:project_id
    add_index :budgets,:dep_id
    add_index :buy_finance_products,:doc_head_id
    add_index :buy_finance_products,:account_id
    add_index :cash_draw_items,:inner_cash_draw_id
    add_index :common_riems,:fee_id
    add_index :common_riems,:dep_id
    add_index :common_riems,:project_id
    add_index :common_riems,:doc_head_id
    add_index :cp_doc_details,:dep_id
    add_index :cp_doc_details,:fee_id
    add_index :cp_doc_details,:project_id
    add_index :cp_doc_details,:doc_head_id
    #doc head
    add_index :doc_heads,:person_id
    add_index :doc_heads,:dep_id
    add_index :doc_heads,:fee_id
    add_index :doc_heads,:project_id
    add_index :doc_heads,:afford_dep_id
    add_index :doc_heads,:real_person_id
    #fee code match
    add_index :fee_code_matches,:fee_id
    add_index :fee_code_matches,:dcode_id
    add_index :fee_code_matches,:ccode_id
    #fee standard
    add_index :fee_standards,:project_id
    add_index :fee_standards,:duty_id
    add_index :fee_standards,:lodging_id
    add_index :fee_standards,:transportation_id
    add_index :fee_standards,:business_type_id
    add_index :fee_standards,:region_type_id
    add_index :fee_standards,:currency_id
    add_index :fee_standards,:fee_id
    add_index :fee_standards,:person_type_id
    #other riems
    add_index :other_riems,:doc_head_id
    add_index :other_riems,:currency_id
    #people
    add_index :people,:dep_id
    add_index :people,:duty_id
    add_index :people,:role_id
    add_index :people,:person_type_id
    #rd benefits
    add_index :rd_benefits,:doc_head_id
    add_index :rd_benefits,:dep_id
    add_index :rd_benefits,:fee_id
    add_index :rd_benefits,:project_id
    #exrta car
    add_index :rd_extra_work_cars,:doc_head_id
    add_index :rd_extra_work_cars,:currency_id
    #extra meal
    add_index :rd_extra_work_meals,:doc_head_id
    add_index :rd_extra_work_meals,:currency_id
    #rd common trans
    add_index :rd_common_transports,:project_id
    add_index :rd_common_transports,:dep_id
    add_index :rd_common_transports,:currency_id
    add_index :rd_common_transports,:doc_head_id
    #rd lodging
    add_index :rd_lodgings,:doc_head_id
    add_index :rd_lodgings,:currency_id
    add_index :rd_lodgings,:region_id
    add_index :rd_lodgings,:region_type_id
    #rd trans
    add_index :rd_transports,:doc_head_id
    add_index :rd_transports,:currency_id
    add_index :rd_transports,:transportation_id
    #rd travels
    add_index :rd_travels,:doc_head_id
    add_index :rd_travels,:region_id
    add_index :rd_travels,:region_type_id
    add_index :rd_travels,:currency_id
    #rd work meal
    add_index :rd_work_meals,:doc_head_id
    add_index :rd_work_meals,:project_id
    add_index :rd_work_meals,:dep_id
    add_index :rd_work_meals,:currency_id
    #reciver
    add_index :recivers,:doc_head_id
    add_index :recivers,:settlement_id
  end

  def self.down
  end
end
