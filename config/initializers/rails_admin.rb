RailsAdmin.config do |config|
  config.included_models = 
    [Dep, Person, Currency,Project,Settlement,
    Duty,WorkFlow,WorkFlowStep,Role,Fee,Region,Transportation,Lodging,
    FeeStandard,Budget,Account,Subject,ExtraWorkStandard,
    Menu,MenuCategory,Supplier,FeeCodeMatch,SystemConfig,DocMetaInfo]

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
