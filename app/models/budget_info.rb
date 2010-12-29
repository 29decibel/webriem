#coding: utf-8
require 'builder'
class BudgetInfo
  attr_accessor :fee,:dep,:project,:current_year,:used,:approving_used,:this_used,:remain
  netzke_exclude_attributes :created_at, :updated_at
  def to_xml(options={})
    if options[:builder]
      build_xml(options[:builder])
    else
      xml = Builder::XmlMarkup.new
      xml.instruct!
      build_xml(xml)
    end
  end
  private
  def build_xml(xml)
    xml.budgets do 
      xml.budget do
        xml.fee fee
        xml.dep dep
        xml.project project
        xml.current_year current_year
        xml.used used
        xml.approving_used approving_used
        xml.this_used this_used
        xml.remain remain
      end
    end
  end
end
