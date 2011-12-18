#coding: utf-8
module SensitiveWordValidation

  module InstanceMethods

    def validate_sensitive_words
      if self.respond_to? 'reason'
        SensitiveWord.all.map(&:name).each do |w|
          if self.reason.include? w
            self.errors.add(:reason,"不能包含关键字#{w}")
            break
          end
        end
      end
    end

  end

  def self.included(receiver)
    receiver.send :include, InstanceMethods
    receiver.validate :validate_sensitive_words
  end

end
