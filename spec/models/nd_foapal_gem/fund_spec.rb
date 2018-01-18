require 'rails_helper'

module NdFoapalGem
  RSpec.describe Fund, type: :model do

    it "returns true if the fund is a grant or cost share fund" do
      f = NdFoapalGem::Fund.new('201732')
      expect(f.is_grant_or_cost_share_fund?).to eq(true)
    end

    it "returns false if the fund is not a grant or cost share fund" do
      f = NdFoapalGem::Fund.new('100000')
      expect(f.is_grant_or_cost_share_fund?).to eq(false)
    end

    it "sets rspa and fund data on initialize" do
      fund_array = [{"fund"=>"201732", "fund_title"=>"PTX-Vanderbilt Sub # 10092651-S1", "predecessor_fund_type"=>"2", "rspa_accountant"=>"LGOO1", "rspa_accountant_last_name"=>"Goo", "rspa_accountant_first_name"=>"Leslie", "fund_type"=>"20", "be_fund_parent"=>"20 - Grants and Contracts"}]
      expect_any_instance_of(NdFoapalGem::FoapalData).to receive(:search).and_return(fund_array)
      f = NdFoapalGem::Fund.new('201732')
      f.set_fund_attributes
      expect(f.rspa_accountant_net_id).to eq('LGOO1')
      expect(f.rspa_accountant_first_name).to eq('Leslie')
      expect(f.rspa_accountant_last_name).to eq('Goo')
      expect(f.predecessor_fund_type).to eq('2')
      expect(f.fund_description).to eq("PTX-Vanderbilt Sub # 10092651-S1")
      expect(f.fund_type).to eq("20")
    end

  end
end
