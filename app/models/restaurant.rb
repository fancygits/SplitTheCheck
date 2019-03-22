class Restaurant < ApplicationRecord



  def vote_will_split
    self.will_split += 1
    self.save
  end

  def vote_wont_split
    self.wont_split += 1
    self.save
  end

end
