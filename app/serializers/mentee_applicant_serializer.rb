class MenteeApplicantSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :family_name, :school, :location, :email, :applicant_status

  # has_many :mentee_applicant_interests
end
