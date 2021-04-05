class MenteeApplicant < ApplicationRecord
  enum us_citizen: { no: 0, yes: 1, international_student: 2 }
  enum applicant_status: { undecided: 0, accepted: 1, rejected: 2 }, _suffix: true
  
  # has_many :mentee_applicant_interests, class_name: 'MenteeApplicantInterests', foreign_key: 'mentee_applicant_id', dependent: :destroy
end
