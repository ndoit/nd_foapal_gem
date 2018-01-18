class FoapalEntry < ActiveRecord::Base
  include NdFoapalGem::FoapalHelper
  include RspaHelper

  belongs_to :parent_record
  before_save :set_fund_type
  before_save :set_acct_type
  before_save :set_rspa_values

  validates_with NdFoapalGem::FoapalValidator

  attr_accessor :foapal_amount_string


  	def foapal_amount_string
  		foapal_amount
  	end

  	def foapal_amount_string=(foapal_amount)
  		if foapal_amount.blank?
  			self.foapal_amount = nil
  		else
  			self.foapal_amount = foapal_amount.gsub(',','').to_f
  		end
  	end


end
