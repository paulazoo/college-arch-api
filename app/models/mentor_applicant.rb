class MentorApplicant < ApplicationRecord
  enum us_citizen: { no: 0, yes: 1, international_student: 2 }

  has_many :interests, class_name: 'MentorApplicantInterests', foreign_key: 'mentor_applicant_id'
  has_many :majors, class_name: 'MentorApplicantMajors', foreign_key: 'mentor_applicant_id'
end
