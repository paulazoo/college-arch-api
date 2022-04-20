class UpdateUsers < ActiveRecord::Migration[6.0]
  def change
    add_column(:users, :info_share, :boolean, default: true)
    add_column(:users, :age, :integer)

    add_column(:users, :dream_colleges, :string)
    
    add_column(:users, :alt_school_email, :string)
  end
end
