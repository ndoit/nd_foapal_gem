require 'rails_helper'

RSpec.describe "parent_records/show", type: :view do
  before(:each) do
    @parent_record = assign(:parent_record, ParentRecord.create!(
      :parent_desc => "Parent Desc"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Parent Desc/)
  end
end
