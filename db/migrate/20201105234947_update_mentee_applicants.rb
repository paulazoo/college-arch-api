class UpdateMenteeApplicants < ActiveRecord::Migration[6.0]
  def change
    add_column(:mentee_applicants, :single_parent, :boolean, default: false)
    add_column(:mentee_applicants, :disabled, :boolean, default: false)
    add_column(:mentee_applicants, :lgbt, :boolean, default: false)
  end
end
