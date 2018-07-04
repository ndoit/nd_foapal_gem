require "rails_helper"

module NdFoapalGem
  describe "FoapalHelper" do

    helper NdFoapalGem::FoapalHelper

    let(:test_new_record_class) do
      Class.new() do
        attr_accessor :fund, :orgn, :acct, :prog, :actv, :locn
        attr_accessor :fund_description, :orgn_description, :acct_description, :prog_description, :actv_description, :locn_description
        attr_accessor :predecessor_fund_type, :predecessor_acct_type, :fund_type, :acct_type, :acct_class

        include NdFoapalGem::FoapalHelper
        include ActiveModel::Validations

        validate :account_type_cannot_be_transfer

        def initialize(params = {})
          self.fund = params[:fund]
          self.fund_description = params[:fund_description]
          self.fund_type = params[:fund_type]
          self.predecessor_fund_type = params[:predecessor_fund_type]
          self.orgn = params[:orgn]
          self.orgn_description = params[:orgn_description]
          self.acct = params[:acct]
          self.acct_description = params[:acct_description]
          self.acct_type = params[:acct_type]
          self.predecessor_acct_type = params[:predecessor_acct_type]
          self.acct_class = params[:acct_class]
          self.prog = params[:prog]
          self.prog_description = params[:prog_description]
          self.actv = params[:actv]
          self.actv_description = params[:actv_description]
          self.locn = params[:locn]
          self.locn_description = params[:locn_description]
        end

        def new_record?
          true
        end

        def fund_changed?
          false
        end

        def acct_changed?
          false
        end
      end
    end

    let(:new_foapal_entry) { test_new_record_class.new() }

    let(:test_changed_record_class) do
      Class.new() do
        attr_accessor :fund, :orgn, :acct, :prog, :actv, :locn
        attr_accessor :fund_description, :orgn_description, :acct_description, :prog_description, :actv_description, :locn_description
        attr_accessor :predecessor_fund_type, :predecessor_acct_type, :fund_type, :acct_type, :acct_class

        include NdFoapalGem::FoapalHelper
        include ActiveModel::Validations

        validate :account_type_cannot_be_transfer

        def initialize(params = {})
          self.fund = params[:fund]
          self.fund_description = params[:fund_description]
          self.fund_type = params[:fund_type]
          self.predecessor_fund_type = params[:predecessor_fund_type]
          self.orgn = params[:orgn]
          self.orgn_description = params[:orgn_description]
          self.acct = params[:acct]
          self.acct_description = params[:acct_description]
          self.acct_type = params[:acct_type]
          self.predecessor_acct_type = params[:predecessor_acct_type]
          self.acct_class = params[:acct_class]
          self.prog = params[:prog]
          self.prog_description = params[:prog_description]
          self.actv = params[:actv]
          self.actv_description = params[:actv_description]
          self.locn = params[:locn]
          self.locn_description = params[:locn_description]
        end

        def new_record?
          false
        end

        def fund_changed?
          true
        end

        def acct_changed?
          true
        end

        def attr_is_not_blank(mattr)
          !self.send(mattr).blank?
        end
      end
    end

    let(:changed_foapal_entry) { test_changed_record_class.new() }

    it "returns a nice label for the different foapal parts" do
      expect(foapal_label('fund')).to eq('Fund')
      expect(foapal_label('acct')).to eq('Account')
      expect(foapal_label('orgn')).to eq('Organization')
      expect(foapal_label('prog')).to eq('Program')
      expect(foapal_label('actv')).to eq('Activity')
      expect(foapal_label('locn')).to eq('Location')
    end

    it "can add an acct error if the account code is a transfer" do
      new_foapal_entry.acct = '81071'
      new_foapal_entry.account_type_cannot_be_transfer
      expect(new_foapal_entry.errors[:acct]).to include('Account 81071 is invalid. Transfer accounts cannot be used on this transactions.')
      changed_foapal_entry.acct = '72001'
      changed_foapal_entry.valid?
      expect(changed_foapal_entry.errors[:acct]).to_not include('Account 81071 is invalid. Transfer accounts cannot be used on this transactions.')
    end

    it "retrieves details for each of part of the foapal" do
      expect(fop_lookup('fund','160002')).to eq([{"fund" => "160002","fund_title" => "Dining Halls","predecessor_fund_type" => "1","rspa_accountant" => "DSHEER","rspa_accountant_last_name" => "Sheer","rspa_accountant_first_name" => "Donna","fund_type" => "10"}])
      expect(fop_lookup('orgn','34000')).to eq([{"orgn" => "34000","orgn_title" => "Dean's Office-Mendoza Coll. of Bus.","be_org_parent" => "H34 - Dean of Mendoza College of Bus "}])
      expect(fop_lookup('acct','72001')).to eq([{"acct" => "72001","acct_title" => "Supplies","acct_type" => "71","predecessor_acct_type" => "70","acct_class" => nil}])
      expect(fop_lookup('prog','70000')).to eq([{"prog" => "70000","prog_title" => "General Administration"}])
      expect(fop_lookup('actv','46647')).to eq([{"actv" => "46647","actv_title" => "Take Back the Night 16102"}])
      expect(fop_lookup('locn','1054')).to eq([{"locn" => "1054","locn_title" => "Pangborn Hall"}])
    end

    it "retrieves an empty array for each part of the foapal if value does not match" do
      expect(fop_lookup('fund','160999')).to eq([{"fund" => "None", "fund_title" => "No matching records"}])
      expect(fop_lookup('orgn','34999')).to eq([{"orgn" => "None", "orgn_title" => "No matching records"}])
      expect(fop_lookup('acct','72999')).to eq([{"acct" => "None", "acct_title" => "No matching records"}])
      expect(fop_lookup('prog','70999')).to eq([{"prog" => "None", "prog_title" => "No matching records"}])
      expect(fop_lookup('actv','00999')).to eq([{"actv" => "None", "actv_title" => "No matching records"}])
      expect(fop_lookup('locn','0099')).to eq([{"locn" => "None", "locn_title" => "No matching records"}])
    end

    it "sets values for fund description, predecessor_fund_type and fund type" do
      changed_foapal_entry.fund = '160002'
      changed_foapal_entry.set_fund_type
      expect(changed_foapal_entry.fund_description).to eq( "Dining Halls")
      expect(changed_foapal_entry.fund_type).to eq( "10")
      expect(changed_foapal_entry.predecessor_fund_type).to eq( "1")
      changed_foapal_entry.fund = '100000'
      changed_foapal_entry.set_fund_type
      expect(changed_foapal_entry.fund_description).to eq( "Educational and General")
      expect(changed_foapal_entry.fund_type).to eq( "10")
      expect(changed_foapal_entry.predecessor_fund_type).to eq( "1")
    end

    it "sets values for acct description, predecessor_acct_type, acct type and acct class" do
      changed_foapal_entry.acct = '72001'
      changed_foapal_entry.set_acct_type
      expect(changed_foapal_entry.acct_description).to eq( "Supplies")
      expect(changed_foapal_entry.acct_type).to eq( "71")
      expect(changed_foapal_entry.predecessor_acct_type).to eq( "70")
      expect(changed_foapal_entry.acct_class).to be_nil
      changed_foapal_entry.acct = '81572'
      changed_foapal_entry.set_acct_type
      expect(changed_foapal_entry.acct_description).to eq( "Funding Transfer-In (NDEP)")
      expect(changed_foapal_entry.acct_type).to eq( "8U")
      expect(changed_foapal_entry.predecessor_acct_type).to eq( "80")
      expect(changed_foapal_entry.acct_class).to eq('U')
    end

    it "sets the corresponding description field value for each part of the foapal" do
      changed_foapal_entry.fund = '160002'
      changed_foapal_entry.orgn = '34000'
      changed_foapal_entry.acct = '72001'
      changed_foapal_entry.prog = '70000'
      changed_foapal_entry.actv = '46647'
      changed_foapal_entry.locn = '1054'
      changed_foapal_entry.set_description('fund')
      expect(changed_foapal_entry.fund_description).to eq('Dining Halls')
      changed_foapal_entry.set_description('orgn')
      expect(changed_foapal_entry.orgn_description).to eq("Dean's Office-Mendoza Coll. of Bus.")
      changed_foapal_entry.set_description('acct')
      expect(changed_foapal_entry.acct_description).to eq("Supplies")
      changed_foapal_entry.set_description('prog')
      expect(changed_foapal_entry.prog_description).to eq("General Administration")
      changed_foapal_entry.set_description('actv')
      expect(changed_foapal_entry.actv_description).to eq("Take Back the Night 16102")
      changed_foapal_entry.set_description('locn')
      expect(changed_foapal_entry.locn_description).to eq("Pangborn Hall")
    end

    it "returns a formated foapal string" do
      changed_foapal_entry.fund = '160002'
      changed_foapal_entry.orgn = '34000'
      changed_foapal_entry.acct = '72001'
      changed_foapal_entry.prog = '70000'
      changed_foapal_entry.actv = '46647'
      changed_foapal_entry.locn = '1054'
      expect(foapal_string(changed_foapal_entry)).to eq('160002-34000-72001-70000-46647-1054')
      changed_foapal_entry.locn = nil
      expect(foapal_string(changed_foapal_entry)).to eq('160002-34000-72001-70000-46647')
      changed_foapal_entry.actv = nil
      expect(foapal_string(changed_foapal_entry)).to eq('160002-34000-72001-70000')
      changed_foapal_entry.locn = '1054'
      expect(foapal_string(changed_foapal_entry)).to eq('160002-34000-72001-70000--1054')
      changed_foapal_entry.acct = nil
      expect(foapal_string(changed_foapal_entry)).to eq('160002-34000-   -70000--1054')
      changed_foapal_entry.orgn = nil
      expect(foapal_string(changed_foapal_entry)).to eq('160002--   -70000--1054')
    end

    it "validates foapal for all account types" do
      changed_foapal_entry.fund = '160002'
      changed_foapal_entry.orgn = '34000'
      changed_foapal_entry.acct = '72001'
      changed_foapal_entry.prog = '70000'
      changed_foapal_entry.actv = '46647'
      changed_foapal_entry.locn = '1054'
      validate_foapal(changed_foapal_entry,'validate')
      expect(changed_foapal_entry.errors[:base]).to include('The FOAP[AL] 160002-34000-72001-70000-46647-1054 is invalid. (Bad defaults for orgn/prog.)')
    end
    it "validates foapal for payroll account types" do
      changed_foapal_entry.fund = '100000'
      changed_foapal_entry.orgn = '34000'
      changed_foapal_entry.acct = '72001'
      changed_foapal_entry.prog = '10000'
      changed_foapal_entry.actv = '99xx'
      validate_foapal(changed_foapal_entry,'validate_payroll')
      expect(changed_foapal_entry.errors[:base]).to include('The FOAP[AL] 100000-34000-72001-10000-99xx is invalid.')
      expect(changed_foapal_entry.errors[:acct]).to include('Account 72001 is invalid.')
      expect(changed_foapal_entry.errors[:actv]).to include('Activity 99xx is invalid.')
    end

    it "validates fopal " do
      changed_foapal_entry.fund = '100000'
      changed_foapal_entry.orgn = '34000'
      changed_foapal_entry.acct = '99999'
      changed_foapal_entry.prog = '10000'
      changed_foapal_entry.actv = '46647'
      changed_foapal_entry.locn = '1054'
      validate_foapal(changed_foapal_entry,'validate_fopal')
      expect(changed_foapal_entry.errors[:base]).to include('The FOAP[AL] 100000-34000-99999-10000-46647-1054 is invalid.')
      changed_foapal_entry = test_changed_record_class.new()
      changed_foapal_entry.fund = '100000'
      changed_foapal_entry.orgn = '34000'
      changed_foapal_entry.prog = '10000'
      changed_foapal_entry.actv = '46647'
      changed_foapal_entry.locn = '1054'
      validate_foapal(changed_foapal_entry,'validate_fopal')
      expect(changed_foapal_entry.errors[:base]).to be_empty
      expect(changed_foapal_entry.errors[:acct]).to be_empty
    end

  end
end
