Webreim::Application.routes.draw do

  get "doc_rows/index"

  devise_for :admin_users,:controllers => { :sessions => "admin_sessions"}
  devise_for :users,:controllers => { :sessions => "user_sessions"}

  get "home/index"

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
    
  get "doc_heads/output_to_txt(.:format)"  
  get "doc_heads/output_to_txt_all(.:format)"
  get "doc_heads/pay"  
  get "doc_heads/print(.:format)"
  get "doc_heads/recall"  
  get "doc_heads/batch_pay"  
  get "doc_heads/batch_print"  
  get "doc_heads/doc_failed"  
  get "doc_heads/batch_approve"  
  put "doc_heads/submit"
  get "doc_heads/mark"
  get "doc_heads/export_xls"

  resources :doc_heads do
    collection do
      get :search
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
    
  root :to=>"home#index"

end
