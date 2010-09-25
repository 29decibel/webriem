class ReimSplitDetail < ActiveRecord::Base
  belongs_to :dep
  belongs_to :project
  belongs_to :fee
  belongs_to :reim_detail
end
