class Menu < ActiveRecord::Base
  NOT_DISPLAY=['menu_type']
  def self.not_display
    NOT_DISPLAY
  end
  def to_s
    "#{title}"
  end
end
