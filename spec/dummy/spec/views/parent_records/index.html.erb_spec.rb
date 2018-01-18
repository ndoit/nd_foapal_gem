require 'rails_helper'

RSpec.describe "parent_records/index", type: :view do
  before(:each) do
    assign(:parent_records, [
      ParentRecord.create!(
        :parent_desc => "Parent Desc"
      ),
      ParentRecord.create!(
        :parent_desc => "Parent Desc"
      )
    ])
  end

  it "renders a list of parent_records" do
    render
    assert_select "tr>td", :text => "Parent Desc".to_s, :count => 2
  end
end
