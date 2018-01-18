require 'rails_helper'

RSpec.describe "parent_records/edit", type: :view do
  before(:each) do
    @parent_record = assign(:parent_record, ParentRecord.create!(
      :parent_desc => "MyString"
    ))
  end

  it "renders the edit parent_record form" do
    render

    assert_select "form[action=?][method=?]", parent_record_path(@parent_record), "post" do

      assert_select "input#parent_record_parent_desc[name=?]", "parent_record[parent_desc]"
    end
  end
end
