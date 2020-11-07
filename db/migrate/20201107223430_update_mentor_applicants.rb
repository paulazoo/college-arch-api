class UpdateMentorApplicants < ActiveRecord::Migration[6.0]
  def change
    add_column(:mentor_applicants, :single_parent, :boolean, default: false)
    add_column(:mentor_applicants, :disabled, :boolean, default: false)
    add_column(:mentor_applicants, :lgbt, :boolean, default: false)
    add_column(:mentor_applicants, :me_na, :boolean, default: false)
    add_column(:mentor_applicants, :us_living, :boolean, default: true)
    add_column(:mentor_applicants, :city, :string)
  end
end
