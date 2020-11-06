class MenteeApplicantSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :family_name, :school, :location, :phone, :email

  # has_many :mentee_applicant_interests
end
