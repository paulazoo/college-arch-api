class MentorApplicantSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :family_name, :school, :us_citizen, :location, :phone, :email, :applicant_status

  # has_many :majors
end
