class RdTransport < ActiveRecord::Base
    belongs_to :reim_detail
    belongs_to :transportation, :class_name => "Transportation", :foreign_key => "transportation_id"
    belongs_to :currency
end
