class RdExtraWorkMeal < ActiveRecord::Base
    belongs_to :reim_detail 
    belongs_to :currency 
end
