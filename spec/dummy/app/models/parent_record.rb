class ParentRecord < ActiveRecord::Base
  has_many :foapal_entries
  accepts_nested_attributes_for :foapal_entries
  validates :name, presence: { message: 'Name is required.'}
end
