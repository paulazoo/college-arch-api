class MenteeApplicantSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :family_name, :school, :location, :email, :phone, :applicant_status, :interests

end
