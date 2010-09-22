class RdLodging < ActiveRecord::Base
  belongs_to :region
  belongs_to :reim_detail
end
