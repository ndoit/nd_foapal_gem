
module NdFoapalGem
  class FoapalValidator < ActiveModel::Validator
    include NdFoapalGem::FoapalHelper


    def validate(record)
        validate_foapal(record,'validate')
    end
  end
end
