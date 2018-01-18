require 'rails_helper'

module NdFoapalGem
  describe "PayrollFoapalValidator" do
    let(:test_record_class) do
      Class.new() do
        attr_accessor :fund, :orgn, :acct, :prog, :actv, :locn
        include ActiveModel::Validations
        validates_with PayrollFoapalValidator

        def initialize(params = {})
          self.fund = params[:fund]
          self.orgn = params[:orgn]
          self.acct = params[:acct]
          self.prog = params[:prog]
          self.actv = params[:actv]
          self.locn = params[:locn]
        end
      end
    end

    let(:foapal_entry) { test_record_class.new() }

    it "validates a valid Payroll foapal" do
      foapal_entry.fund = '100000'
      foapal_entry.orgn = '34005'
      foapal_entry.acct = '64010'
      foapal_entry.prog = '10000'
      foapal_entry.valid?
      expect(foapal_entry.errors[:base]).to be_empty
    end

    it "indicates the record is invalid if the account is not a payroll account" do
      foapal_entry.fund = '100000'
      foapal_entry.orgn = '34005'
      foapal_entry.acct = '72001'
      foapal_entry.prog = '10000'
      foapal_entry.valid?
      expect(foapal_entry.errors[:base]).to_not be_empty
      expect(foapal_entry.errors[:acct]).to_not be_empty
      found_match = false
      foapal_entry.errors[:base].each do |e|
        found_match = true if e.match(/\AThe FOAP\[AL\] 100000/)
      end
      expect(found_match).to eq(true)
      expect(foapal_entry.errors[:acct]).to include('Account 72001 is invalid.')
    end


    it "indicates the record is invalid if the fund is invalid" do
      foapal_entry.fund = '999xx'
      foapal_entry.orgn = '34005'
      foapal_entry.acct = '64010'
      foapal_entry.prog = '10000'
      foapal_entry.valid?
      expect(foapal_entry.errors[:base]).to_not be_empty
      expect(foapal_entry.errors[:fund]).to_not be_empty
      found_match = false
      foapal_entry.errors[:base].each do |e|
        found_match = true if e.match(/\AThe FOAP\[AL\] 999xx/)
      end
      expect(found_match).to eq(true)
      expect(foapal_entry.errors[:fund]).to include('Fund 999xx is invalid.')
    end

    it "indicates the record is invalid if the orgn is invalid" do
      foapal_entry.fund = '100000'
      foapal_entry.orgn = '340xx'
      foapal_entry.acct = '64010'
      foapal_entry.prog = '10000'
      foapal_entry.valid?
      expect(foapal_entry.errors[:base]).to_not be_empty
      expect(foapal_entry.errors[:orgn]).to_not be_empty
      found_match = false
      foapal_entry.errors[:base].each do |e|
        found_match = true if e.match(/\AThe FOAP\[AL\] 100000/)
      end
      expect(found_match).to eq(true)
      expect(foapal_entry.errors[:orgn]).to include('Organization 340xx is invalid.')
    end

    it "indicates the record is invalid if the acct is invalid" do
      foapal_entry.fund = '100000'
      foapal_entry.orgn = '34000'
      foapal_entry.acct = '720xx'
      foapal_entry.prog = '10000'
      foapal_entry.valid?
      expect(foapal_entry.errors[:base]).to_not be_empty
      expect(foapal_entry.errors[:acct]).to_not be_empty
      found_match = false
      foapal_entry.errors[:base].each do |e|
        found_match = true if e.match(/\AThe FOAP\[AL\] 100000/)
      end
      expect(found_match).to eq(true)
      expect(foapal_entry.errors[:acct]).to include('Account 720xx is invalid.')
    end

    it "indicates the record is invalid if the prog is invalid" do
      foapal_entry.fund = '100000'
      foapal_entry.orgn = '34000'
      foapal_entry.acct = '64010'
      foapal_entry.prog = '100xx'
      foapal_entry.valid?
      expect(foapal_entry.errors[:base]).to_not be_empty
      expect(foapal_entry.errors[:prog]).to_not be_empty
      found_match = false
      foapal_entry.errors[:base].each do |e|
        found_match = true if e.match(/\AThe FOAP\[AL\] 100000/)
      end
      expect(found_match).to eq(true)
      expect(foapal_entry.errors[:prog]).to include('Program 100xx is invalid.')
    end

    it "indicates the record is invalid if the actv is invalid" do
      foapal_entry.fund = '100000'
      foapal_entry.orgn = '34000'
      foapal_entry.acct = '64010'
      foapal_entry.prog = '10000'
      foapal_entry.actv = '99xx'
      foapal_entry.valid?
      expect(foapal_entry.errors[:base]).to_not be_empty
      expect(foapal_entry.errors[:actv]).to_not be_empty
      found_match = false
      foapal_entry.errors[:base].each do |e|
        found_match = true if e.match(/\AThe FOAP\[AL\] 100000/)
      end
      expect(found_match).to eq(true)
      expect(foapal_entry.errors[:actv]).to include('Activity 99xx is invalid.')
    end


    it "indicates the record is invalid if the locn is invalid" do
      foapal_entry.fund = '100000'
      foapal_entry.orgn = '34000'
      foapal_entry.acct = '64010'
      foapal_entry.prog = '10000'
      foapal_entry.locn = '99xx'
      foapal_entry.valid?
      expect(foapal_entry.errors[:base]).to_not be_empty
      expect(foapal_entry.errors[:locn]).to_not be_empty
      found_match = false
      foapal_entry.errors[:base].each do |e|
        found_match = true if e.match(/\AThe FOAP\[AL\] 100000/)
      end
      expect(found_match).to eq(true)
      expect(foapal_entry.errors[:locn]).to include('Location 99xx is invalid.')
    end

    it "indicates the record is invalid if the program code is not valid for the fund and orgn" do
      foapal_entry.fund = '100000'
      foapal_entry.orgn = '34000'
      foapal_entry.acct = '64010'
      foapal_entry.prog = '70000'
      foapal_entry.valid?
      expect(foapal_entry.errors[:base]).to_not be_empty
      found_match = false
      foapal_entry.errors[:base].each do |e|
        found_match = true if e.match(/\AThe FOAP\[AL\] 100000/) && e.match(/(Org-prog combination is invalid for fund 100000.)/)
      end
      expect(found_match).to eq(true)
    end

  end
end
