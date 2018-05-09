require 'open-uri'
require 'json'

class InvalidParams < StandardError
end

module NdFoapalGem
  class FoapalData
    include ActiveModel::Validations

    attr_accessor :data_type, :search_string, :type
    attr_accessor :fund, :orgn, :acct, :prog, :actv, :locn

    validates :data_type, presence: { message: 'Data type is required.' }
    validates :data_type, inclusion: {in: %w(validate validate_payroll fund orgn acct prog actv locn epac), message: 'Data type passed to foapal lookup is not valid.'}
    validates :fund, :acct, format: {with: /\A[0-9a-zA-Z]{5,6}\Z/, message: 'FOAP elements must be 5 or 6 alphanumeric characters.', allow_blank: true}
    validates :orgn, :prog, format: {with: /\A([0-9a-zA-Z]{5,6}|No match)\Z/, message: 'FOAP elements must be 5 or 6 alphanumeric characters.', allow_blank: true}
    validates :actv, :locn, format: {with: /\A[0-9a-zA-Z]{1,6}\Z/, message: 'Activity and location codes may be up to 6 alphanumeric characters.', allow_blank: true}
    validates :type, format: {with: /\A[0-9a-zA-Z]{2}\Z/, message: 'Type must be two alphanumeric characters.', allow_blank: true}
    validates :search_string, length: {maximum: 36, message: 'Search string can be up to 36 characters.', allow_blank: true}
    validate :foap_required, if: :performing_validation?

    def initialize(params = {})
      self.data_type = params[:data_type]
      self.search_string = params[:search_string]
      self.type = params[:type]
      self.fund = params[:fund]
      self.orgn = params[:orgn]
      self.acct = params[:acct]
      self.prog = params[:prog]
      self.actv = params[:actv]
      self.locn = params[:locn]
    end

    def search
      self.valid?
      raise InvalidParams unless self.valid?
      url_open = URI.parse(self.lookup_url)
      search_results = JSON.parse(url_open.read)

      if search_results.empty?
            return JSON.parse('[{ "' + data_type + '": "None", "' + data_type+'_title": "No matching records"}]')
      else
            return search_results
      end

      rescue => e
        case e
        when InvalidParams
          return JSON.parse('[{ "' + data_type + '": "Error", "' + data_type+'_title": "Invalid Parameters"}]')
        when OpenURI::HTTPError
          return JSON.parse('[{ "' + data_type + '": "None", "' + data_type+'_title": "No matching records"}]')
        when SocketError
          return JSON.parse('[{ "' + data_type + '": "Error", "' + data_type+'_title": "A socket error has occurred"}]')
        when URI::InvalidURIError
          return JSON.parse('[{ "' + data_type + '": "Error", "' + data_type+'_title": "Invalid URI"}]')
        else
          return JSON.parse('[{ "' + data_type + '": "Error", "' + data_type+'_title": "An unknown error was encountered. "}]')
        end

      rescue SystemCallError => e
        if e === Errno::ECONNRESET
          if data_type == "epac"
            return JSON.parse('[{ "acct": "Error", "acct_title": "Server not available"}]')
          else
            return JSON.parse('[{ "' + data_type + '": "Error", "' + data_type+'_title": "Server not available"}]')
          end
        else
          raise e
        end

    end

    def searchAcctDataString
      search_results = self.search
      acctData = search_results.map {|s| {value: s['acct'], label: "#{s['acct']} - #{s['acct_title']}"}}
      acctData.to_json
    end

    def lookup_url
          lookup_url = "#{ENV['FIN_API_BASE']}/fop/v1/"
          lookup_url += URI::escape(self.query_string)
          lookup_url += "?api_key=#{ENV['FINANCE_API_KEY']}"
    end

    def query_string
        qs = data_type
        qs += "/f" if data_type == 'orgn' && !fund.blank?
        qs += "/" + fund unless fund.blank?
        qs += "/" + orgn unless orgn.blank?
        if performing_validation?
            qs += "/" + acct
            qs += "/" + prog
        end
        qs += "/" + actv unless actv.blank?
        qs += "/ " if performing_validation? && actv.blank? && !locn.blank?  # does this need to included payroll_validate?
        qs += "/" + locn unless locn.blank?
        qs += "/t/" + type unless type.blank?
        qs += "/" + search_string unless search_string.blank?
        return qs
    end

    def performing_validation?  # ? at the end
      ['validate','validate_payroll'].include?(data_type)
    end

    def foap_contains_blanks?
       (fund.blank? || orgn.blank? || acct.blank? || prog.blank?)
    end

    def foap_contains_no_match?
      (fund.upcase == "NO MATCH" || orgn.upcase == "NO MATCH" || acct.upcase == "NO MATCH" || prog.upcase == "NO MATCH")
    end

    def foap_required
      errors.add(:base, 'Check your foapal entries.  Fund, Organization, Account, Program must be entered.') and return if foap_contains_blanks?
      errors.add(:base, 'Check your foapal entries.  A value of No Match indicates an invalid value in Fund and/or Organization.')  if foap_contains_no_match?
    end

  end
end
