require 'rails_helper'

module NdFoapalGem
  RSpec.describe Acct, type: :model do

    it "sets account attributes" do
      acct_array = [{"acct":"72001","acct_title":"Supplies","acct_type":"71","predecessor_acct_type":"70","acct_class":nil}]
      expect_any_instance_of(NdFoapalGem::FoapalData).to receive(:search).and_return(acct_array)
      a = NdFoapalGem::Acct.new('72001')
      a.set_acct_attributes

      expect(a.predecessor_acct_type).to eq('70')
      expect(a.acct_description).to eq("Supplies")
      expect(a.acct_type).to eq("71")
      expect(a.acct_class).to be_nil

    end

  end
end
