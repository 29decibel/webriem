class ImplementActivity < ActiveRecord::Base
  has_paper_trail
  belongs_to :vrv_project
end
