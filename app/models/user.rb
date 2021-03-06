class User < ApplicationRecord
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable,
         :validatable, authentication_keys: [:login]
  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  validates :username, format: { with: /^[a-zA-Z0-9_\.]*$/, multiline: true,
                                  message: 'can only use letters, numbers, and underscore.' }
  validate :validate_username

 # Virtual attribute for authenticating by either username or email
 # This is in addition to a real persisted field like 'username'
  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_h).first
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def has_voted_for?(restaurant)
    self.votes.find_by(restaurant_id: restaurant.id).present?
  end

  def vote_for(restaurant, split)
    unless has_voted_for?(restaurant)
      self.votes.create(restaurant_id: restaurant.id, split: split)
    end
  end

  def has_favorited?(restaurant)
    self.favorites.find_by(restaurant_id: restaurant.id).present?
  end

  def favorite(restaurant)
    fav = self.favorites.find_by(restaurant_id: restaurant.id)
    if fav.present?
      fav.destroy
    else
      self.favorites.create(restaurant_id: restaurant.id)
    end
  end

end
