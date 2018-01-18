require 'rails_helper'

module NdFoapalGem
  RSpec.describe FoapalData, type: :model do

    it "is invalid if data type is not set" do
    	fd = NdFoapalGem::FoapalData.new()
      expect(fd.valid?).to eq(false)
      found_error = true if fd.errors[:data_type].include?('Data type is required.')
      expect(found_error).to eq(true)
  	end

    it "is invalid data type is not validate, fund, orgn, acct, prog, actv, locn or epac" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'vv'})
      expect(fd.valid?).to eq(false)
      found_error = true if fd.errors[:data_type].include?('Data type passed to foapal lookup is not valid.')
      fd.data_type = 'validate'
      fd.valid?
      expect(fd.errors[:data_type]).to be_empty
      fd.data_type = 'fund'
      fd.valid?
      expect(fd.errors[:data_type]).to be_empty
      fd.data_type = 'orgn'
      fd.valid?
      expect(fd.errors[:data_type]).to be_empty
      fd.data_type = 'acct'
      fd.valid?
      expect(fd.errors[:data_type]).to be_empty
      fd.data_type = 'prog'
      fd.valid?
      expect(fd.errors[:data_type]).to be_empty
      fd.data_type = 'actv'
      fd.valid?
      expect(fd.errors[:data_type]).to be_empty
      fd.data_type = 'locn'
      fd.valid?
      expect(fd.errors[:data_type]).to be_empty
      fd.data_type = 'epac'
      fd.valid?
      expect(fd.errors[:data_type]).to be_empty
  	end

    it "verifies fund, orgn, acct, prog elements are 5 or 6 alphanumeric characters" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'fund', fund: '100000'})
      fd.valid?
      expect(fd.errors[:fund]).to be_empty
      fd.fund = '100%00'
      fd.valid?
      expect(fd.errors[:fund].include?('FOAP elements must be 5 or 6 alphanumeric characters.')).to eq(true)
      fd.fund = '100000'
      fd.orgn = '1111'
      fd.acct = '1111111'
      fd.prog = 'a-0090'
      fd.valid?
      expect(fd.errors[:orgn].include?('FOAP elements must be 5 or 6 alphanumeric characters.')).to eq(true)
      expect(fd.errors[:acct].include?('FOAP elements must be 5 or 6 alphanumeric characters.')).to eq(true)
      expect(fd.errors[:prog].include?('FOAP elements must be 5 or 6 alphanumeric characters.')).to eq(true)
    end

    it "verifies actv and locn elements are alphanumeric and up to 6 characters" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'validate', actv: '1000', 'locn': '9'})
      fd.valid?
      expect(fd.errors[:actv]).to be_empty
      expect(fd.errors[:locn]).to be_empty
      fd.actv = '100%00'
      fd.locn = '1234567'
      fd.valid?
      expect(fd.errors[:actv].include?('Activity and location codes may be up to 6 alphanumeric characters.')).to eq(true)
      expect(fd.errors[:locn].include?('Activity and location codes may be up to 6 alphanumeric characters.')).to eq(true)
    end

    it "verifies type is 2 alphanumeric characters" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'acct', type: '10'})
      fd.valid?
      expect(fd.errors[:type]).to be_empty
      fd.type = '100'
      fd.valid?
      expect(fd.errors[:type].include?('Type must be two alphanumeric characters.')).to eq(true)
      fd.type = '1%'
      fd.valid?
      expect(fd.errors[:type].include?('Type must be two alphanumeric characters.')).to eq(true)
    end

    it "verifies search_string is up to 36 characters" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'acct', search_string: '290'})
      fd.valid?
      expect(fd.errors[:search_string]).to be_empty
      fd.search_string = 'Supplies'
      fd.valid?
      expect(fd.errors[:search_string]).to be_empty
      fd.search_string = 'R&D'
      fd.valid?
      expect(fd.errors[:search_string]).to be_empty
      fd.search_string = '1234567890123456789012345678901234567'
      fd.valid?
      expect(fd.errors[:search_string].include?('Search string can be up to 36 characters.')).to eq(true)
    end

    it "requires a value in fund, orgn, acct and prog for validation" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'validate', fund: nil, orgn: '34000', acct: '72001', prog: '10000'})
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  Fund, Organization, Account, Program must be entered.')
      fd.fund = '100000'
      fd.orgn = ''
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  Fund, Organization, Account, Program must be entered.')
      fd.orgn = '34000'
      fd.acct = ''
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  Fund, Organization, Account, Program must be entered.')
      fd.acct = '72001'
      fd.prog = nil
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  Fund, Organization, Account, Program must be entered.')
    end

    it "requires a value in fund, orgn, acct and prog for payroll account validation" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'validate_payroll', fund: nil, orgn: '34000', acct: '72001', prog: '10000'})
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  Fund, Organization, Account, Program must be entered.')
      fd.fund = '100000'
      fd.orgn = ''
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  Fund, Organization, Account, Program must be entered.')
      fd.orgn = '34000'
      fd.acct = ''
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  Fund, Organization, Account, Program must be entered.')
      fd.acct = '72001'
      fd.prog = nil
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  Fund, Organization, Account, Program must be entered.')
    end

    it "requires a fund, orgn, acct and prog are a value other than No Match for validation" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'validate', fund: 'No Match', orgn: '34000', acct: '72001', prog: '10000'})
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  A value of No Match indicates an invalid value in Fund and/or Organization.')
      fd.fund = '100000'
      fd.orgn = 'No Match'
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  A value of No Match indicates an invalid value in Fund and/or Organization.')
      fd.orgn = '34000'
      fd.acct = 'No match'
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  A value of No Match indicates an invalid value in Fund and/or Organization.')
      fd.acct = '72001'
      fd.prog = 'No match'
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  A value of No Match indicates an invalid value in Fund and/or Organization.')
    end

    it "requires a fund, orgn, acct and prog are a value other than No Match for payroll validation" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'validate_payroll', fund: 'No Match', orgn: '34000', acct: '72001', prog: '10000'})
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  A value of No Match indicates an invalid value in Fund and/or Organization.')
      fd.fund = '100000'
      fd.orgn = 'No Match'
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  A value of No Match indicates an invalid value in Fund and/or Organization.')
      fd.orgn = '34000'
      fd.acct = 'No match'
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  A value of No Match indicates an invalid value in Fund and/or Organization.')
      fd.acct = '72001'
      fd.prog = 'No match'
      fd.valid?
      expect(fd.errors[:base]).to include('Check your foapal entries.  A value of No Match indicates an invalid value in Fund and/or Organization.')
    end

    it "finds an fund by fund code" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'fund', fund: '100000'})
      funds = fd.search
      expect(funds.count).to eq(1)
      expect(funds[0]['fund_title'].upcase).to match('EDUCATIONAL')
      expect(funds[0]['fund_title'].upcase).to match('GENERAL')
    end

    it "finds orgn by a specific fund code" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'orgn', fund: '201732'})
      orgns = fd.search
      expect(orgns.count).to eq(1)
      expect(orgns[0]['orgn_title'].upcase).to match('ELECTRICAL ENGINEERING')
    end

    it "finds accounts for a specific eclass" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'epac', search_string: 'S1'})
      accts = fd.search
      expect(accts.count).to eq(1)
      expect(accts[0]['acct_title'].upcase).to match('STAFF-ADMINISTRATIVE')
    end

    it "returns acctData for use in Javascript for a specific eclass" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'epac', search_string: 'S1'})
      acctDataString = fd.searchAcctDataString
      expect(acctDataString).to eq([{value: '64010', label: '64010 - Staff-Administrative'}].to_json)
    end

    it "finds accounts for a specific account type" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'acct', type: '16'})
      accts = fd.search
      expect(accts.count).to be > 1
      expect(accts[0]['acct_title'].upcase).to match('EQUIPMENT')
    end

    it "finds programs for a specific fund/orgn" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'prog', fund: '100000', orgn: '34005'})
      progs = fd.search
      expect(progs.count).to eq(2)
      expect(progs[0]['prog_title'].upcase).to match('INSTRUCTION')
    end

    it "finds list of matching activities" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'actv', search_string: "Cafe 'd"})
      actvs = fd.search
      expect(actvs.count).to be >= 1
      expect(actvs[0]['actv_title'].upcase).to match('CAFE')
    end

    it "indicates a non Payroll FOAPAL is valid" do
      fd = NdFoapalGem::FoapalData.new({data_type: 'validate', fund: "100000", orgn: '34005', acct: '72001', prog: '100000'})

    end
  end
end
