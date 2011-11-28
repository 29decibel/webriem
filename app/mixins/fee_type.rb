module FeeType
  def self.included(klass)
    klass.class_eval <<-EOF
      def fee_type
        self.respond_to?(:fee) ? self.fee : DocRowMetaInfo.find_by_name(self.class.name).try(:fee)
      end
    EOF
  end
end
