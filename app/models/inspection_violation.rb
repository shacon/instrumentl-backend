class InspectionViolation < ApplicationRecord
  belongs_to :inspection
  belongs_to :risk_category
end