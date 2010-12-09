class AdaptRate < ActiveRecord::Migration
  def self.up
    change_column :buy_finance_products,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :common_riems,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :cp_doc_details,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :inner_remittances,:now_rate_price,:decimal,:precision => 14,  :scale => 4
    change_column :rd_common_transports,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :rd_extra_work_cars,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :rd_extra_work_meals,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :rd_lodgings,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :rd_transports,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :rd_travels,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :rd_work_meals,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :rec_notice_details,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :redeem_finance_products,:rate,:decimal,:precision => 14,  :scale => 4
    change_column :reim_details,:rate,:decimal,:precision => 14,  :scale => 4
  end

  def self.down
  end
end
