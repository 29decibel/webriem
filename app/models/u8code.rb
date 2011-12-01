class U8code < ActiveRecord::Base
  #default is the end code can be selected 
  default_scope :conditions=>"bend=1"
  def to_s
    ccode_name
  end
  def name
    "[#{ccode}]#{ccode_name}"
  end
end
