class CreatePayrollAccountsParentRecord < ActiveRecord::Migration
  def change
    create_table :payroll_accounts_parent_records do |t|
      t.string :name
      t.string :orgn
      t.string :orgn_description
      t.string :eclass
      t.timestamps null: false
    end
  end
end
