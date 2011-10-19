Webreim::Application.routes.draw do
  mount Resque::Server, :at => "/resque"

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users,:controllers => { :sessions => "user_sessions"}

  get "home/index"
  get "home/change_locale"
  get "home/deployment"
  get "home/contact_us"
  get "home/apply_demo"
  post "home/register_demo"

  get "doc_off_set/index"
  post "doc_off_set/search"
  get "doc_off_set/remove_offset"
  post "doc_off_set/do_offset"

  #post "vouch/update" i don't know why this doesn't work???
  get "vouch/index"
  get "vouch/generate"
  get "vouch/rg_vouch"
  match "vouch/edit"=>"vouch#edit"
  match "vouch/update"=>"vouch#update"
  match "vouch/g_u8"=>"vouch#g_u8"

  get "common/new_reset_p"
  post "common/reset_p"
  
  get "pri_task/reset_pw"
  get "pri_task/adapt_menu"
  get "pri_task/fuck_date"
  post "pri_task/fuck_p"
  get "/pri_task/cmds"
  get "pri_task/import_project"
  get "pri_task/import_person"
  get "pri_task/test_curb"
  get "pri_task/import_u8_codes"
  get "pri_task/import_u8_deps"

  get "ajax_service/getfee"  
  get "ajax_service/getbudget"  
  get "ajax_service/remove_offset",:as=>:remove_offset  
  get "ajax_service/get_extrafee"

  resources :doc_heads do
    member do
      put :adjust_amount
    end
    collection do
      get :search
      get :export_to_txt
      get :pay  
      get :print
      get :recall  
      get :batch_pay  
      get :batch_print  
      get :doc_failed  
      get :batch_approve  
      put :submit
      get :mark
      get :export_to_xls
    end
  end
  resources :doc_rows
  resources :currency
  resources :work_flow_infos

  get "token_input/search"
  resources :upload_files
  
  get "task/my_docs",:as=>:my_docs  
  get "task/docs_to_approve",:as=>:docs_to_approve  
  get "task/docs_approved"  
  get "task/docs_to_pay"  
  get "task/docs_paid"
  get "task/dashboard"
    
  root :to=>"task#dashboard"

end
