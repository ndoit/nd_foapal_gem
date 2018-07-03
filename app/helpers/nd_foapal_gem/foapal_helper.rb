
module NdFoapalGem
	module FoapalHelper

		FOAPAL_LABELS = {fund: 'Fund', orgn: 'Organization', acct: 'Account', prog: 'Program', actv: 'Activity', locn: 'Location'}

		def foapal_label(p)
			FOAPAL_LABELS[p.to_sym]
		end


		def account_type_cannot_be_transfer
      errors.add(:acct,"Account #{acct} is invalid. Transfer accounts cannot be used on this transactions.") if self.predecessor_acct_type == '80'
    end

		def fop_lookup(foap_part,part_value)  # rename foap_lookup
			f = NdFoapalGem::FoapalData.new( data_type: foap_part)
			f.send("#{foap_part}=",part_value)
			foap_part_results = f.search
		rescue => e
			Rails::logger.error("Error in FOP lookup #{e.message} on #{foap_part} #{part_value}")
			raise e
		end

    def set_fund_type
      return true if fund.blank?
      if fund_type.blank? || predecessor_fund_type.blank?
        f = NdFoapalGem::Fund.new(fund)
				f.set_fund_attributes if f.valid?
        self.predecessor_fund_type = f.predecessor_fund_type
        self.fund_type = f.fund_type
        self.fund_description = f.fund_description
      end
    end

    def set_acct_type
      return true if acct.blank?
      if acct_type.blank? && predecessor_acct_type.blank? && acct_class.blank?
        a = NdFoapalGem::Acct.new(acct)
        a.set_acct_attributes if a.valid?
        self.acct_type = a.acct_type
        self.acct_class = a.acct_class
        self.predecessor_acct_type = a.predecessor_acct_type
        self.acct_description = a.acct_description
      end
    end

		def set_description(foapal_element)
			return if self[foapal_element.to_sym].blank?
			element_data = fop_lookup(foapal_element,self[foapal_element.to_sym])
			unless element_data.empty?
				self["#{foapal_element}_description".to_sym] = element_data[0]["#{foapal_element}_title"] if self[foapal_element.to_sym] ==  element_data[0]["#{foapal_element}"]
			end
		end


		def foapal_string(foapal_record)
			acct_output = foapal_record.acct
			acct_output ||= '   '
			fs = foapal_record.fund + "-" + foapal_record.orgn + "-" + acct_output + "-" +  foapal_record.prog
			fs += "-" + foapal_record.actv.to_s unless foapal_record.actv.blank? && foapal_record.locn.blank?
			fs += "-" + foapal_record.locn.to_s unless foapal_record.locn.blank?
			fs
		end

    def set_errors_from_foapal_validator(validator_results,record)
        v_errors = {}
        unless validator_results[0] && validator_results[0].has_key?('overall')
          error_string = "An error occurred while trying to validate FOAP[AL] values.  "
          error_string += "Please verify that the Notre Dame financial data web service is available. "
          v_errors[:base] = error_string
          return v_errors
        end
        vr = validator_results[0]
        return v_errors if vr["overall"] == 'valid'
        error_string = "The FOAP[AL] #{foapal_string(record)} is invalid."
        v_errors[:fund] = "Fund #{record.fund} is invalid." if vr["fund"] == "invalid" || vr["fund"] == "null"
        v_errors[:orgn] = "Organization #{record.orgn} is invalid." if vr["orgn"] == "invalid" || vr["orgn"] == "null"
        v_errors[:acct] = "Account #{record.acct} is invalid."  if vr["acct"] == "invalid" || vr["acct"] == "null"
        v_errors[:prog] = "Program #{record.prog} is invalid." if vr["prog"] == "invalid" || vr["prog"] == "null"
        v_errors[:actv] = "Activity #{record.actv} is invalid." if vr["actv"] == "invalid"
        v_errors[:locn] = "Location #{record.locn} is invalid." if vr["locn"] == "invalid"

        unless vr["foapal"].blank?
          case vr["foapal"][0-9]
          when "BAD DEFAULTS FOR ORGN/PROG"
              v_errors[:prog] = " Invalid Orgn/Prog combination. Orgn [#{record.orgn}] Prog [#{record.prog}]."
          when "NULL LOCN","NULL ACTV"
              error_string += ""
          else
              error_string += " (#{vr["foapal"].capitalize}.)" unless vr["foapal"].upcase.match(/\ABAD FOAPAL/)
          end
        end

        v_errors[:base] = error_string
        return v_errors

        rescue => e
            Rails::logger.error("Error in FoapalValidator: #{e.message}")
	          error_string = "An error occurred while trying to validate FOAP[AL] values.  "
            error_string += "Please verify that the Notre Dame financial data web service is available. (#{e.message})"
            v_errors[:base] = error_string
            return v_errors
    end

		def validate_foapal(record,validation_type)
				f = NdFoapalGem::FoapalData.new( data_type: validation_type,
					fund: record.fund, orgn: record.orgn, acct: record.acct, prog: record.prog, actv: record.actv, locn: record.locn)
				unless f.valid?
					f.errors.each do |key,value|
						record.errors[key] << value
					end
					return
				end
				validator_results = f.search

				v_errors = set_errors_from_foapal_validator(validator_results, record)
				v_errors.each do |field_symbol,error|
					record.errors[field_symbol] << error
				end
		rescue => e
			Rails::logger.error("Error in validate_foapal #{e.message}")
		end

	end

end
