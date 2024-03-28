class Owner < ApplicationRecord
  has_many :restaurants, dependent: :nullify
end