class NoUnitizedAccountsValidator < ActiveModel::Validator
  def validate(record)
    if record.acct_class == 'U'
      record.errors[:acct] << "Account #{record.acct} is invalid.  Unitized accounts are not permitted."
    end       

  end
end