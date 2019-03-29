class Restaurant < ApplicationRecord

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
