#coding: utf-8
class FeeStandard < ActiveRecord::Base
  belongs_to :project
  belongs_to :region
  belongs_to :duty
  belongs_to :lodging
  belongs_to :transportation
  enum_attr :busitype,[['借款',0],['报销',1],['其他',2]]
  def project_name
    if self.project==nil
      ""
    else
      self.project.name
    end
  end
  def region_name
    if self.region==nil
      ""
    else
      self.region.name
    end
  end
  def duty_name
    if self.duty==nil
      ""
    else
      self.duty.name
    end
  end
  def lodging_name
    if self.lodging==nil
      ""
    else
      self.lodging.name
    end
  end
  def transportation_name
    if self.transportation==nil
      ""
    else
      self.transportation.name
    end
  end
end
