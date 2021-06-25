class InterestsColumn < ActiveRecord::Migration[6.0]
  def change
    drop_table :mentor_applicant_interests
    drop_table :mentee_applicant_interests
  end
end
