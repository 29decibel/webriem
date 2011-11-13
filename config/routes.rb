Webreim::Application.routes.draw do

  resources :doc_amount_changes

  resources :vrv_projects do
    member do
      put :submit
      put :approve
      put :reject
    end
    resources :customer_contacts
    resources :implement_activities
    resources :bill_afters
    resources :bill_stages
    resources :contract_predicts
    resources :bill_prepares
    resources :product_tests
    resources :busi_communications
    resources :tech_communications
    resources :network_conditions
    resources :competitors
  end

  resource "doc_row_resource"

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  mount Resque::Server, :at => "/resque"

  ActiveAdmin.routes(self)

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

  get "ajax_service/getfee"  
  get "ajax_service/getbudget"  
  get "ajax_service/remove_offset",:as=>:remove_offset  
  get "ajax_service/get_extrafee"

  resources :doc_heads do
    resources :work_flow_infos
    member do
      put :adjust_amount
      put :pay
      put :recall  
      put :submit
      get :print_preview
    end
    collection do
      get :search
      get :export_to_txt
      get :batch_pay  
      get :doc_failed  
      get :batch_approve  
      get :mark
      get :export_to_xls
    end
  end
  resources :doc_rows
  resources :currency
  resources :approver_infos

  get "token_input/search"
  resources :upload_files
  
  get "task/my_docs",:as=>:my_docs  
  get "task/docs_to_approve",:as=>:docs_to_approve  
  get "task/docs_approved"  
  get "task/docs_to_pay"  ,:as => :docs_to_pay
  get "task/docs_paid"
  get "task/dashboard"
    
  root :to=>"task#dashboard"

end
