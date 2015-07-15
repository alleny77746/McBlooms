# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Menu.create(title: "Shop Our Products", url: "/categories", type: :main_navigation)

["About Us", "Heritage", "Customer Service"].each do |title|
  Page.create(title: title, content: "Coming soon...", start_on: Time.now, menu_type: :top_navigation)
end

["Our Ingredients", "About Skincare", "FAQ"].each do |title|
  Page.create(title: title, content: "Coming soon...", start_on: Time.now, menu_type: :main_navigation)
end

contact_us_page = Page.create(title: "Contact Us", content: "Coming soon...", start_on: Time.now, menu_type: :main_navigation)
Menu.create(title: "Contact Us", page: contact_us_page, type: :footer)


["Terms & Conditions", "Privacy Policy", "Exchange & Returns", "Shipping & Handling", "New Distributor Info"].each do |title|
  Page.create(title: title, content: "Coming soon...", start_on: Time.now, menu_type: :footer)
end