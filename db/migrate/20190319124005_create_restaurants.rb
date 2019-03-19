class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :cuisine
      t.string :street_address
      t.string :city
      t.string :state
      t.string :postcode
      t.integer :will_split
      t.integer :wont_split

      t.timestamps
    end
  end
end
