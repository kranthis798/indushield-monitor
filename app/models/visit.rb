class Visit < ApplicationRecord
  belongs_to :device
  belongs_to :company
  belongs_to :department
  belongs_to :service_type
end
