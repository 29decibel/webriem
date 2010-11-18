class ChangeDecimalColumnAll < ActiveRecord::Migration
  def self.up
	#budgets
    change_column :budgets,:jan,:decimal,        :precision => 16, :scale => 2
    change_column :budgets,:feb,:decimal,        :precision => 16, :scale => 2
    change_column :budgets,:mar,:decimal,        :precision => 16, :scale => 2
    change_column :budgets,:apr,:decimal,        :precision => 16, :scale => 2
    change_column :budgets,:may,:decimal,        :precision => 16, :scale => 2
    change_column :budgets,:jun,:decimal,        :precision => 16, :scale => 2
    change_column :budgets,:jul,:decimal,        :precision => 16, :scale => 2
    change_column :budgets,:aug,:decimal,        :precision => 16, :scale => 2
    change_column :budgets,:sep,:decimal,        :precision => 16, :scale => 2
    change_column :budgets,:oct,:decimal,        :precision => 16, :scale => 2
    change_column :budgets,:nov,:decimal,        :precision => 16, :scale => 2
    change_column :budgets,:dec,:decimal,        :precision => 16, :scale => 2	
	change_column :buy_finance_products,:amount,:decimal,        :precision => 16, :scale => 2
	change_column :cash_draw_items,:apply_amount,:decimal,        :precision => 16, :scale => 2
	change_column :common_riems,:apply_amount,:decimal,        :precision => 16, :scale => 2
	change_column :common_riems,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :cp_doc_details,:apply_amount,:decimal,        :precision => 16, :scale => 2
	change_column :cp_doc_details,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :currencies,:default_rate,:decimal,        :precision => 10, :scale => 4
	change_column :doc_heads,:cp_doc_remain_amount,:decimal,        :precision => 16, :scale => 2
	change_column :doc_heads,:total_amount,:decimal,        :precision => 16, :scale => 2
	change_column :extra_work_standards,:amount,:decimal,        :precision => 16, :scale => 2
	change_column :fee_standards,:amount,:decimal,        :precision => 16, :scale => 2
	change_column :inner_cash_draws,:now_remain_amout,:decimal,        :precision => 16, :scale => 2
	change_column :inner_remittances,:amount,:decimal,        :precision => 16, :scale => 2
	change_column :inner_remittances,:remain_amount,:decimal,        :precision => 16, :scale => 2
	change_column :inner_remittances,:in_amount_after,:decimal,        :precision => 16, :scale => 2
	change_column :inner_transfers,:out_amount_before,:decimal,        :precision => 16, :scale => 2
	change_column :inner_transfers,:in_amount_before,:decimal,        :precision => 16, :scale => 2
	change_column :inner_transfers,:amount,:decimal,        :precision => 16, :scale => 2
	change_column :inner_transfers,:in_amount_after,:decimal,        :precision => 16, :scale => 2
	change_column :other_riems,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :other_riems,:apply_amount,:decimal,        :precision => 16, :scale => 2
	change_column :other_riems,:hr_amount,:decimal,        :precision => 16, :scale => 2
	change_column :other_riems,:fi_amount,:decimal,        :precision => 16, :scale => 2
	change_column :other_riems,:rate,:decimal,        :precision => 10, :scale => 4
	change_column :rd_benefits,:amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_benefits,:hr_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_benefits,:fi_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_common_transports,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_common_transports,:apply_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_extra_work_cars,:fi_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_extra_work_cars,:hr_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_extra_work_cars,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_extra_work_cars,:apply_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_extra_work_meals,:fi_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_extra_work_meals,:hr_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_extra_work_meals,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_extra_work_meals,:apply_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_lodgings,:fi_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_lodgings,:hr_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_lodgings,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_lodgings,:apply_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_transports,:fi_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_transports,:hr_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_transports,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_transports,:apply_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_travels,:fi_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_travels,:hr_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_travels,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_travels,:apply_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_work_meals,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rd_work_meals,:apply_amount,:decimal,        :precision => 16, :scale => 2
	change_column :recivers,:fi_amount,:decimal,        :precision => 16, :scale => 2
	change_column :recivers,:hr_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rec_notice_details,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :rec_notice_details,:amount,:decimal,        :precision => 16, :scale => 2
	change_column :recivers,:amount,:decimal,        :precision => 16, :scale => 2
	change_column :redeem_finance_products,:amount,:decimal,        :precision => 16, :scale => 2
	change_column :reim_details,:real_amount,:decimal,        :precision => 16, :scale => 2
	change_column :reim_details,:ori_amount,:decimal,        :precision => 16, :scale => 2
	change_column :reim_details,:amount,:decimal,        :precision => 16, :scale => 2
  end

  def self.down
  end
end
