module FeeType
  def self.included(klass)
    klass.class_eval <<-EOF
      def fee_type
        config_fee = DocRowMetaInfo.find_by_name(self.class.name).try(:fee)
        return config_fee if config_fee
        self.respond_to?(:fee) ? self.fee : config_fee
      end
    EOF
  end
end
