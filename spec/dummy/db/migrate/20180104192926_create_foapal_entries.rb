class CreateFoapalEntries < ActiveRecord::Migration
  def change
    create_table :foapal_entries do |t|
      t.string :fund
      t.string :fund_description
      t.string :fund_type
      t.string :predecessor_fund_type
      t.string :orgn
      t.string :orgn_description
      t.string :acct
      t.string :acct_description
      t.string :acct_type
      t.string :predecessor_acct_type
      t.string :acct_class
      t.string :prog
      t.string :prog_description
      t.string :actv
      t.string :actv_description
      t.string :locn
      t.string :locn_description
      t.float  :foapal_amount
      t.integer :parent_record_id
      t.boolean :is_grant_or_cost_share_fund
      t.string :rspa_accountant_net_id
      t.string :rspa_accountant_first_name
      t.string :rspa_accountant_last_name

      t.timestamps
    end
  end
end
