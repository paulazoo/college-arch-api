class MentorApplicantSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :family_name, :school, :us_citizen, :location, :phone, :email

  has_many :interests
  has_many :majors
end
