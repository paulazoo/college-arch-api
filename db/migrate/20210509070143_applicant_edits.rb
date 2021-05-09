class ApplicantEdits < ActiveRecord::Migration[6.0]
  def change
    add_column(:mentee_applicants, :hobby, :string)
    add_column(:mentor_applicants, :hobby, :string)
    add_column(:mentee_applicants, :extra_component, :string)
    add_column(:mentor_applicants, :extra_component, :string)
  end
end
