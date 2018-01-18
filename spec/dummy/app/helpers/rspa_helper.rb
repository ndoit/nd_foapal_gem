module RspaHelper
  def set_rspa_values
    f = NdFoapalGem::Fund.new(fund)
    self.is_grant_or_cost_share_fund = f.is_grant_or_cost_share_fund?
    if self.is_grant_or_cost_share_fund
      f.set_fund_attributes
      self.rspa_accountant_net_id = f.rspa_accountant_net_id
      self.rspa_accountant_first_name = f.rspa_accountant_first_name
      self.rspa_accountant_last_name = f.rspa_accountant_last_name
    end
  end

end
