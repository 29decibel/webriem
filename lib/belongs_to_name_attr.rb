module MIKE
  module FRIENDLY
    def blongs_to_name_attr(attr_name) 
      self.class_eval(%Q{
        def #{attr_name}_name
          if(#{attr_name}==nil)
            ""
          else
            #{attr_name}.name
          end
        end
      })
    end
  end
end