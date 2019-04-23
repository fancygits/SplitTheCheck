require 'csv'

Restaurant.delete_all

Restaurant.create!( name: 'Bad Apple',
                    cuisine: 'American',
                    street_address: '4300 N Lincoln Ave',
                    city: 'Chicago',
                    state: 'IL',
                    postcode: '60618')
csv_text = File.read(Rails.root.join('lib', 'restaurants.csv'))
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  r = Restaurant.new
  r.name = row['name']
  r.cuisine = row['cuisine']
  r.street_address = row['street_address']
  r.city = row['city']
  r.state = row['state']
  r.postcode = row['postcode']
  r.save
end
puts "There are now #{Restaurant.count} rows in the restaurant table."
