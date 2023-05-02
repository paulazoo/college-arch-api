class AddImportanceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column(:users, :importance, :string)
  end
end
