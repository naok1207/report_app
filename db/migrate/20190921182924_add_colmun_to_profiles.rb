class AddColmunToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :image, :string
  end
end
