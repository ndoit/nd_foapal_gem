
module NdFoapalGem
  class FopalValidator < ActiveModel::Validator
    include NdFoapalGem::FoapalHelper


    def validate(record)
        validate_foapal(record,'validate_fopal')
    end
  end
end
