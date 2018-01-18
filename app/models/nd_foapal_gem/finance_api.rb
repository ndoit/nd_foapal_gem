require 'persistent_httparty'

module NdFoapalGem
  class FinanceApi
    include HTTParty
    persistent_connection_adapter({ :name => 'NDapi_client',
                                    :pool_size => 10,
                                    :keep_alive => 300,
                                    :idle_timeout => 10 })
    base_uri "#{ENV['FIN_API_BASE']}"

  end
end
