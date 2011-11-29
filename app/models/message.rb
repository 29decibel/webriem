class Message < ActiveRecord::Base
  scope :available,where("start_time<? and end_time>?",Time.now,Time.now)
end
