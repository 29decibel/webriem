class DocRowMetaInfo < ActiveRecord::Base
  belongs_to :fee

  def all_attributes
    eval(name).column_names.reject{|c|%w(id created_at updated_at).include? c}.join(',')
  end
end
