class AddSchoolAndGradYear < ActiveRecord::Migration[6.0]
  def change
    add_column(:users, :school, :string)
    add_column(:users, :grad_year, :integer)
  end
end
