class Reciver < ActiveRecord::Base
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
  belongs_to :settlement, :class_name => "Settlement", :foreign_key => "settlement_id"
  blongs_to_name_attr :settlement
end
