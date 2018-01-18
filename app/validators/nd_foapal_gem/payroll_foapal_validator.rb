
module NdFoapalGem
  class PayrollFoapalValidator < ActiveModel::Validator
    include NdFoapalGem::FoapalHelper


    def validate(record)

        validate_foapal(record,'validate_payroll')
    end
  end
end
