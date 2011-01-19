class U8Dep < ActiveRecord::Base
  def to_s
    cdepcode
  end
  def name
    cdepname
  end
end
