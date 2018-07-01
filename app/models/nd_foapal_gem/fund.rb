require 'open-uri'
require 'json'

class InvalidParams < StandardError
end

module NdFoapalGem
  class Fund
    include ActiveModel::Validations

    attr_accessor :fund, :fund_description
    attr_accessor :predecessor_fund_type, :fund_type, :fund_description
    attr_accessor :rspa_accountant_net_id, :rspa_accountant_first_name, :rspa_accountant_last_name

    RSPA_FUND_RANGE_LOW="200000"
		RSPA_FUND_RANGE_HIGH="309999"
		RSPA_RECHARGE_FUND_PREFIX="390"

    validates :fund, format: {with: /\A[0-9a-zA-Z]{5,6}\Z/, message: 'Fund code must be 5 or 6 alphanumeric characters.', allow_blank: true}

    def initialize(fund)
      self.fund = fund
    end

    def set_fund_attributes
      fd = NdFoapalGem::FoapalData.new({data_type: 'fund', fund: fund})
      fund_data = fd.search
			return if fund_data.empty?
      if fund_data[0]['fund'] == 'Error'
        Rails::logger.error("Error in get fund data #{fund_data[0]['fund_title']}")
        raise StandardError, "An error occurred while querying data for fund #{fund}"
        return
      end
      if fund_data[0]['fund'] == fund
        set_fund_attributes_from_hash(fund_data[0])
      else
        set_fund_attributes_from_hash({})
      end
    end

    def set_fund_attributes_from_hash(fund_data)
      @rspa_accountant_net_id = fund_data['rspa_accountant']
      @rspa_accountant_first_name = fund_data['rspa_accountant_first_name']
      @rspa_accountant_last_name = fund_data['rspa_accountant_last_name']
      @predecessor_fund_type = fund_data["predecessor_fund_type"]
      @fund_type = fund_data["fund_type"]
      @fund_description = fund_data["fund_title"]
    end

		def is_grant_or_cost_share_fund?
			(fund >= RSPA_FUND_RANGE_LOW && fund <= RSPA_FUND_RANGE_HIGH) ||
						 fund[0..RSPA_RECHARGE_FUND_PREFIX.length()-1] == RSPA_RECHARGE_FUND_PREFIX
		end

  end
end
