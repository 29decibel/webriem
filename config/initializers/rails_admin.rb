RailsAdmin.config do |config|
  config.included_models = 
    [Dep, Person, Currency,Project,Settlement,
    Duty,WorkFlow,WorkFlowStep,Role,Fee,Region,Transportation,Lodging,
    FeeStandard,Budget,Account,Subject,ExtraWorkStandard,Menu,MenuCategory]

  #config.model Person do
  #  label "Person Model"
  #end  

  config.navigation.max_visible_tabs 8

  #config.model Dep do
  #  dropdown 'BasicSettings'
  #end  

  #config.model Settlement do
  #  dropdown 'BasicSettings'
  #  weight -1
  #end  
end
