class Restaurant < ApplicationRecord
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :name, :cuisine, :street_address, :city, :state, :postcode, presence: true
  validates :name, uniqueness: true
  validates :state, length: { is: 2 }, format: { with: /\A[A-Z]+\z/, message: "is only 2 uppercase letters"}


  # Searches the database for similar names or returns all
  def self.search(search)
    if search
      restaurant = Restaurant.where('LOWER(name) LIKE :term
                                      OR LOWER(cuisine) LIKE :term
                                      OR LOWER(street_address) LIKE :term
                                      OR LOWER(city) LIKE :term
                                      OR LOWER(state) LIKE :term
                                      OR LOWER(postcode) LIKE :term',
                                      term: "%#{search.downcase}%")
      if restaurant.count.zero?
        raise StandardError.new "Searching for \"#{search}\" yielded no results."
        restaurant = Restaurant.all
        throw :abort
      end
      return restaurant
    else
      Restaurant.all
    end
  end

  def will_split
    self.votes.where(split: 'will_split').count
  end

  def wont_split
    self.votes.where(split: 'wont_split').count
  end

end
