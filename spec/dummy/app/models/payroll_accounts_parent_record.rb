class PayrollAccountsParentRecord < ActiveRecord::Base
  has_many :payroll_accounts_foapal_entries
  accepts_nested_attributes_for :payroll_accounts_foapal_entries
  validates :name, presence: { message: 'Name is required.'}
  validates :eclass, presence: { message: 'Employee class is required.'}

  def acctDataForJavascript
    fd = NdFoapalGem::FoapalData.new({data_type: 'epac', search_string: eclass})
    fd.searchAcctDataString
  end
end
