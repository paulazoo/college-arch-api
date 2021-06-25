class AddInterestsColumns < ActiveRecord::Migration[6.0]
  def change
    add_column(:mentee_applicants, :interests, :string)
    add_column(:mentor_applicants, :interests, :string)
  end
end
