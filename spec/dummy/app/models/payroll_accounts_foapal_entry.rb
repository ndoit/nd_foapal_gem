class PayrollAccountsFoapalEntry < ActiveRecord::Base
  include NdFoapalGem::FoapalHelper
  include RspaHelper

  belongs_to :payroll_accounts_parent_record
  before_save :set_fund_type
  before_save :set_acct_type
  before_save :set_rspa_values

  validates_with NdFoapalGem::PayrollFoapalValidator

  attr_accessor :foapal_percent_string


  	def foapal_percent_string
  		foapal_percent
  	end

  	def foapal_percent_string=(foapal_percent)
  		if foapal_percent.blank?
  			self.foapal_percent = nil
  		else
  			self.foapal_percent = foapal_percent.gsub(',','').to_f
  		end
  	end

end
