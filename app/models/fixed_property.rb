class FixedProperty < ActiveRecord::Base
  belongs_to :keeper,:class_name=>"Person",:foreign_key=>"keeper_id"
  belongs_to :afford_dep, :class_name => "Dep", :foreign_key => "afford_dep_id"
  belongs_to :project
  belongs_to :property_type
end
