require 'open-uri'
require 'json'

class InvalidParams < StandardError
end

module NdFoapalGem
  class FopDataController < ApplicationController

    protect_from_forgery with: :exception

    def search
      f = NdFoapalGem::FoapalData.new(params)
      search_results = f.search
      if search_results.empty?
            render :json => JSON.parse('[{ "' + params[:data_type] + '": "None", "' + params[:data_type]+'_title": "No matching records"}]')
      else
            render :json => search_results
      end
    end

  end
end
