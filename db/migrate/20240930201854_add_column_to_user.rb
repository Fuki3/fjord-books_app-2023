class AddColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, default: '', limit: 100
    add_column :users, :self_introduction, :string, limit: 500
    add_column :users, :postcode, :integer
    add_column :users, :address, :string
  end
end
