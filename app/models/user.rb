class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :permissions, dependent: :destroy
  has_one :profile

  delegate :name, to: :profile

  validates :profile, presence: true

  def roles_for(application: )
    permissions.for_application(application).map(&:role)
  end

  def organisation
    profile.organisation
  end
end
