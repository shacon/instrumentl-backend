class AddIndexToRestaurantName < ActiveRecord::Migration[6.1]
  def change
    add_index :restaurants, :name
  end
end
