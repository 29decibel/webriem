#coding: utf-8
# this is the module used to index 
# the doc rows
module AdjustAmount
  def self.included(klass)
    klass.class_eval <<-EOF
      def adjust_amount(attr,amount)
        # 应该使用fi or hr金额的总和来计算
        amount = amount.to_f
        if amount>0 and amount <= self.apply_amount and self.respond_to?(attr)
          minus_amount = (self.try(attr.to_sym) || self.apply_amount) - amount
          self.update_attribute attr.to_sym,amount
          # update recivers
          # minus one by one
          self.doc_head.recivers.each do |r|
            if minus_amount <= r.amount
              r.update_attribute attr.to_sym,(r.try(attr.to_sym) || r.amount)-minus_amount
              break
            else
              minus_amount = minus_amount - (r.try(attr.to_sym) || r.amount)
              r.update_attribute attr.to_sym,0
            end
          end
        end
      end
    EOF
  end
end
