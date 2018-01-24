class CreateLimitedOrgTest < ActiveRecord::Migration
  def change
    create_table :limited_org_tests do |t|
      t.string :name
      t.string :orgn_one
      t.string :orgn_one_description
      t.string :orgn_two
      t.string :orgn_two_description
      t.timestamps null: false      
    end
  end
end
