Rails.application.routes.draw do
  resources :precs
  root 'parent_records#index'
  get '/parent_records/new/:approval_flag(/:email_detail_cb_flag)', to: 'parent_records#new'
  resources :parent_records
  resources :payroll_accounts_parent_records
  mount NdFoapalGem::Engine => "/nd_foapal_gem"
end
