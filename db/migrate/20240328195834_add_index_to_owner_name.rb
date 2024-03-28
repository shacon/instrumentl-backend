class AddIndexToOwnerName < ActiveRecord::Migration[6.1]
  def change
    add_index :owners, :name
  end
end
