class AdaptRateAmount < ActiveRecord::Migration
  def self.up
    change_column :budgets,:jan,:decimal ,:precision => 8, :scale => 2
    change_column :budgets,:feb,:decimal ,:precision => 8, :scale => 2
    change_column :budgets,:mar,:decimal ,:precision => 8, :scale => 2
    change_column :budgets,:apr,:decimal ,:precision => 8, :scale => 2
    change_column :budgets,:may,:decimal ,:precision => 8, :scale => 2
    change_column :budgets,:jun,:decimal ,:precision => 8, :scale => 2
    change_column :budgets,:jul,:decimal ,:precision => 8, :scale => 2
    change_column :budgets,:aug,:decimal ,:precision => 8, :scale => 2
    change_column :budgets,:sep,:decimal ,:precision => 8, :scale => 2
    change_column :budgets,:oct,:decimal ,:precision => 8, :scale => 2
    change_column :budgets,:nov,:decimal ,:precision => 8, :scale => 2
    change_column :budgets,:dec,:decimal ,:precision => 8, :scale => 2
    change_column :buy_finance_products,:amount,:decimal ,:precision => 8, :scale => 2
    change_column :cash_draw_items,:apply_amount,:decimal ,:precision => 8, :scale => 2
    change_column :cp_doc_details,:apply_amount,:decimal ,:precision => 8, :scale => 2
    change_column :cp_doc_details,:ori_amount,:decimal ,:precision => 8, :scale => 2
    change_column :fee_standards,:amount,:decimal ,:precision => 8, :scale => 2
    change_column :inner_cash_draws,:now_remain_amout,:decimal ,:precision => 8, :scale => 2
    change_column :inner_remittances,:amount,:decimal ,:precision => 8, :scale => 2
    change_column :inner_remittances,:remain_amount,:decimal ,:precision => 8, :scale => 2
    change_column :inner_transfers,:out_amount_before,:decimal ,:precision => 8, :scale => 2
    change_column :inner_transfers,:in_amount_before,:decimal ,:precision => 8, :scale => 2
    change_column :inner_transfers,:in_amount_after,:decimal ,:precision => 8, :scale => 2
    change_column :rd_benefits,:amount,:decimal ,:precision => 8, :scale => 2
    change_column :rec_notice_details,:amount,:decimal ,:precision => 8, :scale => 2
    change_column :rec_notice_details,:ori_amount,:decimal ,:precision => 8, :scale => 2
    change_column :recivers,:amount,:decimal ,:precision => 8, :scale => 2
    change_column :redeem_finance_products,:amount,:decimal ,:precision => 8, :scale => 2
    change_column :reim_details,:amount,:decimal ,:precision => 8, :scale => 2
    change_column :reim_details,:ori_amount,:decimal ,:precision => 8, :scale => 2
    change_column :reim_details,:real_amount,:decimal ,:precision => 8, :scale => 2
    change_column :reim_split_details,:percent,:decimal ,:precision => 8, :scale => 2
    #here is the rate area
    change_column :buy_finance_products,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :common_riems,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :cp_doc_details,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :inner_remittances,:now_rate_price,:decimal ,:precision => 6, :scale => 4
    change_column :other_riems,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :rd_common_transports,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :rd_extra_work_cars,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :rd_extra_work_meals,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :rd_lodgings,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :rd_transports,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :rd_travels,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :rd_work_meals,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :rec_notice_details,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :redeem_finance_products,:rate,:decimal ,:precision => 6, :scale => 4
    change_column :reim_details,:rate,:decimal ,:precision => 6, :scale => 4
  end

  def self.down
  end
end
