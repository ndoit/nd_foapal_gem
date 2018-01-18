require 'rails_helper'

RSpec.describe "parent_records/new", type: :view do
  before(:each) do
    assign(:parent_record, ParentRecord.new(
      :parent_desc => "MyString"
    ))
  end

  it "renders new parent_record form" do
    render

    assert_select "form[action=?][method=?]", parent_records_path, "post" do

      assert_select "input#parent_record_parent_desc[name=?]", "parent_record[parent_desc]"
    end
  end
end
