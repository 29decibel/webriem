class U8code < ActiveRecord::Base
  #default is the end code can be selected 
  def to_s
    ccode_name
  end
  def name
    "[#{ccode}]#{ccode_name}"
  end
end
