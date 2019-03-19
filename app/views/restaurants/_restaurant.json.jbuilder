json.extract! restaurant, :id, :name, :cuisine, :street_address, :city, :state, :postcode, :will_split, :wont_split, :created_at, :updated_at
json.url restaurant_url(restaurant, format: :json)
