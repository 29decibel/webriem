class AdjustAmountColumns < ActiveRecord::Migration
  def self.up
    remove_column :doc_heads,:rate      
    remove_column :doc_heads,:currency_id
    remove_column :doc_heads,:apply_amount
    remove_column :doc_heads,:ori_amount
    remove_column :doc_heads,:real_amount
    remove_column :doc_heads,:reim_description
    #add to details
    add_column :rd_common_transports,:rate,:decimal,:precision => 8, :scale => 2
    add_column :rd_common_transports,:currency_id,:integer
    add_column :rd_common_transports,:ori_amount,:decimal,:precision => 8, :scale => 2
    remove_column :rd_common_transports,:final_amount
    #===========================
    add_column :rd_extra_work_cars,:rate,:decimal,:precision => 8, :scale => 2      
    add_column :rd_extra_work_cars,:currency_id,:integer
    add_column :rd_extra_work_cars,:ori_amount,:decimal,:precision => 8, :scale => 2
    remove_column :rd_extra_work_cars,:final_amount
    #===========================
    add_column :rd_extra_work_meals,:rate,:decimal,:precision => 8, :scale => 2      
    add_column :rd_extra_work_meals,:currency_id,:integer
    add_column :rd_extra_work_meals,:ori_amount,:decimal,:precision => 8, :scale => 2
    remove_column :rd_extra_work_meals,:final_amount
    #===========================
    add_column :rd_lodgings,:rate,:decimal,:precision => 8, :scale => 2      
    add_column :rd_lodgings,:currency_id,:integer
    add_column :rd_lodgings,:ori_amount,:decimal,:precision => 8, :scale => 2
    remove_column :rd_lodgings,:final_amount
    #===========================
    add_column :rd_transports,:rate,:decimal,:precision => 8, :scale => 2      
    add_column :rd_transports,:currency_id,:integer
    add_column :rd_transports,:ori_amount,:decimal,:precision => 8, :scale => 2
    remove_column :rd_transports,:final_amount
    #===========================
    add_column :rd_travels,:rate,:decimal,:precision => 8, :scale => 2      
    add_column :rd_travels,:currency_id,:integer
    add_column :rd_travels,:ori_amount,:decimal,:precision => 8, :scale => 2
    remove_column :rd_travels,:final_amount
    #===========================
    add_column :rd_work_meals,:rate,:decimal,:precision => 8, :scale => 2      
    add_column :rd_work_meals,:currency_id,:integer
    add_column :rd_work_meals,:ori_amount,:decimal,:precision => 8, :scale => 2
    remove_column :rd_work_meals,:final_amount
    #change some coumns
    change_column :rd_common_transports,:apply_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_common_transports,:hr_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_common_transports,:fi_amount,:decimal,:precision => 8, :scale => 2
    #-----------------------
    change_column :rd_extra_work_cars,:apply_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_extra_work_cars,:hr_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_extra_work_cars,:fi_amount,:decimal,:precision => 8, :scale => 2
    #-----------------------
    change_column :rd_extra_work_meals,:apply_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_extra_work_meals,:hr_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_extra_work_meals,:fi_amount,:decimal,:precision => 8, :scale => 2
    #-----------------------
    change_column :rd_lodgings,:apply_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_lodgings,:hr_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_lodgings,:fi_amount,:decimal,:precision => 8, :scale => 2
    #-----------------------
    change_column :rd_transports,:apply_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_transports,:hr_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_transports,:fi_amount,:decimal,:precision => 8, :scale => 2
    #-----------------------
    change_column :rd_travels,:apply_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_travels,:hr_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_travels,:fi_amount,:decimal,:precision => 8, :scale => 2
    #-----------------------
    change_column :rd_work_meals,:apply_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_work_meals,:hr_amount,:decimal,:precision => 8, :scale => 2
    change_column :rd_work_meals,:fi_amount,:decimal,:precision => 8, :scale => 2
    #-----------------------
  end

  def self.down
  end
end
