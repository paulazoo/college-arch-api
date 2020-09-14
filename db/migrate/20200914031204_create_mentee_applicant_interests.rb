class CreateMenteeApplicantInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :mentee_applicant_interests do |t|

      t.timestamps
      t.references(:mentee_applicant, null: false, foreign_key: true)
      t.string(:interest)
    end
  end
end
