RailsAdmin.config do |config|
  config.included_models = 
    [Dep, Person, Currency,Project,Settlement,
    Duty,WorkFlow,WorkFlowStep,Role,Fee,Region,Transportation,Lodging,
    FeeStandard,Budget,Account,Subject,ExtraWorkStandard,
    Menu,MenuCategory,Supplier,FeeCodeMatch,SystemConfig,DocMetaInfo,RegionType]

  #config.model Person do
  #  label "Person Model"
  #end  
  config.model WorkFlowStep do
    edit do
      field :dep_id
      field :is_self_dep
      field :duty_id
      field :max_amount
    end
    create do
      field :dep_id
      field :is_self_dep
      field :duty_id
      field :max_amount
    end
  end  

  config.model Dep do
    edit do
      field :name
      field :code
      field :version
      field :start_date
      field :end_date
      field :u8dep_code
      field :u8_dep_id
      field :parent_dep_id
    end
    create do
      field :name
      field :code
      field :version
      field :start_date
      field :end_date
      field :u8dep_code
      field :u8_dep_id
      field :parent_dep_id
    end
  end

  config.model Fee do
    edit do
      field :name
      field :code
      field :end_date
      field :parent_fee_id
    end
    create do
      field :name
      field :code
      field :end_date
      field :parent_fee_id
    end
  end

  config.navigation.max_visible_tabs 8

  RailsAdmin.authenticate_with do
    authenticate_admin_user!
  end

  #config.model Dep do
  #  dropdown 'BasicSettings'
  #end  

  #config.model Settlement do
  #  dropdown 'BasicSettings'
  #  weight -1
  #end  
end
