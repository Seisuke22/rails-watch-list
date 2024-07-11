class AddImageToLists < ActiveRecord::Migration[7.1]
  def change
    add_column :lists, :image, :string
  end
end
