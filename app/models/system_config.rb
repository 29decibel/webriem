class SystemConfig < ActiveRecord::Base
  def self.value(key)
    SystemConfig.find_by_key(key).try(:value)
  end
end
