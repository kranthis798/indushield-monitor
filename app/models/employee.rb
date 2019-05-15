class Employee < ApplicationRecord
  belongs_to :company
  belongs_to :department

  enum status: [:active, :inactive]
end
