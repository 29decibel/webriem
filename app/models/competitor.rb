class Competitor < ActiveRecord::Base
  has_paper_trail :class_name=>'VrvProjectVersion'
  belongs_to :vrv_project


end
