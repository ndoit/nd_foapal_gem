Rails.application.routes.draw do
  resources :precs
  root 'parent_records#index'
  get '/parent_records/new/:approval_flag(/:email_detail_cb_flag)', to: 'parent_records#new'
  get '/limited_org_tests/:number_of_orgns', to: 'limited_org_tests#new'
  resources :parent_records
  resources :payroll_accounts_parent_records
  resources :limited_org_tests
  mount NdFoapalGem::Engine => "/nd_foapal_gem"
end
