Webreim::Application.routes.draw do

  resources :fee_code_matches

  get "vouch/index"
  get "vouch/generate"
  get "vouch/rg_vouch"
  get "vouch/edit"
  post "vouch/update"

  resources :system_configs

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

  get "ajax_service/getfee"  
  get "ajax_service/getbudget"  
  get "ajax_service/remove_offset",:as=>:remove_offset  
  get "ajax_service/get_extrafee"
    
  get "doc_heads/output_to_txt(.:format)"  
  get "doc_heads/pay"  
  get "doc_heads/print(.:format)"
  get "doc_heads/giveup"  
  get "doc_heads/batch_pay"  
  get "doc_heads/batch_print"  
  get "doc_heads/doc_failed"  
  get "doc_heads/batch_approve"  
  get "doc_heads/begin_work"
  get "doc_heads/mark"
  get "doc_heads/export_xls"

  resources :roles

  post "model_search/with"  
  get "model_search/index"  

  get "ref_form/index"
  
  resources :upload_files
  resources :extra_work_standards
  resources :feed_backs
  resources :work_flow_infos
  resources :work_flows
  resources :accounts
  resources :recivers
  resources :doc_heads  
  resources :subjects
  resources :currencies
  resources :budgets
  resources :fee_standards
  resources :projects
  resources :settlements
  resources :lodgings
  resources :transportations
  resources :regions
  resources :fees
  resources :people
  resources :duties
  resources :deps
  
  get "task/my_docs",:as=>:my_docs  
  get "task/docs_to_approve",:as=>:docs_to_approve  
  get "task/docs_approved"  
  get "task/docs_to_pay"  
  get "task/docs_paid"
  
  devise_for :users
    
  root :to=>"task#my_docs"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
