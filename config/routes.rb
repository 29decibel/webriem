Webreim::Application.routes.draw do

  get "ajax_service/getfee"
  
  get "ajax_service/remove_offset",:as=>:remove_offset
  
  get "doc_heads/pay"

  resources :roles

  post "model_search/with"
  
  get "model_search/index"
  
  get "doc_heads/begin_work"

  resources :upload_files

  get "ref_form/index"

  resources :feed_backs

  resources :work_flow_infos

  resources :work_flows

  resources :accounts

  resources :recivers

  resources :doc_heads  
  
  get "task/my_docs",:as=>:my_docs
  
  get "task/docs_to_approve"
  
  devise_for :users

  resources :subjects,:currencies,:budgets,:fee_standards,:projects,:settlements,:lodgings,:transportations,:regions,:fees,:people,:duties,:deps
    
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
