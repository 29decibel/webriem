class RdBenefit < ActiveRecord::Base
  belongs_to :reim_detail  
  has_attached_file :details,
                    :storage => :filesystem,
                    :path => "benefits/:style.:extension"
end
