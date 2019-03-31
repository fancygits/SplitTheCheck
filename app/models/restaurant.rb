class Restaurant < ApplicationRecord

  class Error < StandardError
  end

  # Searches the database for similar names or returns all
  def self.search(search)
    if search
      restaurant = Restaurant.where('LOWER(name) LIKE ?', "%#{search.downcase}%").order('name')

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

  # Increases the will_split or wont_split vote by 1
  def vote(split)
    if split == 'wont_split'
      self.wont_split += 1
    elsif split == 'will_split'
      self.will_split += 1
    end
    self.save
  end

end
