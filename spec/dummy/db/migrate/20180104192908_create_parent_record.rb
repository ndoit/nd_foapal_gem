class CreateParentRecord < ActiveRecord::Migration
  def change
    create_table :parent_records do |t|
      t.string :name
      t.string :orgn
      t.string :orgn_description
      t.timestamps null: false
    end
  end
end
