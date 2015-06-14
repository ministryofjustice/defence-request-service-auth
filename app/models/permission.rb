class Permission < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :application, class_name: "Doorkeeper::Application"
  belongs_to :organisation

  validates :user, :role, presence: true
  validates_uniqueness_of :user_id, scope: [:role_id, :application_id, :organisation_id]

  scope :for_application, ->(application) {
    where(application: application)
  }

  delegate :name, to: :organisation, prefix: true, allow_nil: true
end
