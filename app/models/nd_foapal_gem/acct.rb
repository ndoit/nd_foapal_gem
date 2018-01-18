require 'open-uri'
require 'json'

class InvalidParams < StandardError
end

module NdFoapalGem
  class Acct
    include ActiveModel::Validations

    attr_accessor :acct, :acct_description
    attr_accessor :acct_type, :acct_class, :predecessor_acct_type, :acct_description


    validates :acct, format: {with: /\A[0-9a-zA-Z]{5,6}\Z/, message: 'Acct code must be 5 or 6 alphanumeric characters.'}

    def initialize(acct)
      self.acct = acct
    end

    def set_acct_attributes
      fd = NdFoapalGem::FoapalData.new({data_type: 'acct', search_string: acct})
      acct_data = fd.search
			return if acct_data.empty?
      if acct_data[0]['acct'] == 'Error'
        Rails::logger.error("Error in get acct data #{acct_data[0]['acct_title']}")
        raise StandardError, "An error occurred while querying data for acct #{acct} #{acct_data[0]['acct_title']}"
        return
      end
      @acct_type = acct_data[0]["acct_type"]
      @acct_class = acct_data[0]["acct_class"]
      @predecessor_acct_type = acct_data[0]["predecessor_acct_type"]
      @acct_description = acct_data[0]["acct_title"]

    end

	end
end
