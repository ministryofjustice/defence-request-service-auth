class ProfileForm < Reform::Form
  include Composition
  include Reform::Form::ActiveRecord

  property :name, on: :profile
  property :email, on: :profile
  property :tel, on: :profile
  property :mobile, on: :profile
  property :address, on: :profile
  property :postcode, on: :profile

  model :profile

  property :password, on: :user
  property :password_confirmation, on: :user, empty: true

  validates :name, :address, :postcode, :email, presence: true

  validates :email, uniqueness: true, email: { strict_mode: true }

  validates :password, presence: true,
    confirmation: true, length: { minimum: 8 }, if: :validate_password?

  def id
    model[:profile].id
  end

  def organisation
    model[:profile].organisation
  end

  # Also save the email on the user model to keep devise happy
  # TODO: don't store the email in 2 places
  def email=(val)
    super(val)
    model[:user].email = val
  end

  def validate_password?
    has_associated_user? && model[:user].new_record?
  end

  attr_accessor :has_associated_user
  alias :has_associated_user? :has_associated_user

  def has_associated_user=(val)
    @has_associated_user = val == "1"
  end

  def validate(params)
    self.has_associated_user = params.delete(:has_associated_user)
    super(params)
  end
  alias :create :validate
  alias :update :validate

  def save
    return false unless valid?
    sync
    profile = model[:profile]
    profile.user = model[:user] if has_associated_user?
    profile.save
  end

  private

  # Devise integration
  def active_for_authentication?
    true
  end

  def authenticatable_salt
    model[:user].authenticatable_salt
  end
end

