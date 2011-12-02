class OutwareDocDetail < ActiveRecord::Base
  belongs_to :doc_head
  def self.read_only_attr?(attr)
    %w(contract_no).include?(attr)
  end
end
