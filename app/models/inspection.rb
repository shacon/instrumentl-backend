class Inspection < ApplicationRecord
  belongs_to :restaurant
  has_many :inspection_violations, dependent: :destroy
end