NdFoapalGem::Engine.routes.draw do
  get 'fop_data/:data_type/f/:fund/o/:orgn(/:search_string)' => 'fop_data#search'
  get 'fop_data/:data_type/f/:fund(/:search_string)' => 'fop_data#search'
  get 'fop_data/:data_type/t/:type(/:search_string)' => 'fop_data#search'
  get 'fop_data/:data_type/:fund/:orgn/:acct/:prog(/:actv(/:locn))' => 'fop_data#search'
  get 'fop_data/:data_type(/:search_string)' => 'fop_data#search'
end
