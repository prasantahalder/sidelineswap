# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

puts "Creating roles"
admin_role = Role.create!(:name => 'admin')
moderator_role = Role.create!(:name => 'moderator')

puts "Creating Addresses"

a1_s = Address.create!(:first_name => 'Joe', :last_name => 'Somebody', :street_1 => '123 Duh St',
  :street_2 => '#212', :city => 'Somewhere', :state => 'CA', :zip => '12345', :phone => '5551231234')

a1_b = a1_s.clone
a1_b.save!

a2_s = Address.create!(:first_name => 'Bo', :last_name => 'Somebody', :street_1 => '123 Duh St',
  :street_2 => '#213', :city => 'Somewhere', :state => 'CA', :zip => '12345', :phone => '5553211234')

a2_b = a2_s.clone
a2_b.save!

a3_s = Address.create!(:first_name => 'Schmoe', :last_name => 'Somebody', :street_1 => '123 Duh St',
  :street_2 => '#214', :city => 'Somewhere', :state => 'CA', :zip => '12345', :phone => '5553211234')

a3_b = a3_s.clone
a3_b.save!

puts "Creating users"

u = User.new(:first_name => 'Admin', :last_name => 'Admin',
  :email => 'noah@0x7a69.net', :password => 'admin',
  :password_confirmation => 'admin')

u.shipping_address = a1_s
u.billing_address = a1_b
u.login = 'admin'
u.role = admin_role
u.save!

u = User.new(:first_name => 'User1', :last_name => 'User',
  :email => 'nobody@0x7a69.net', :password => 'user1',
  :password_confirmation => 'user1')

u.shipping_address = a2_s
u.billing_address = a2_b
u.login = 'user1'
u.save!

u = User.new(:first_name => 'User2', :last_name => 'User',
  :email => 'nobody2@0x7a69.net', :password => 'user2',
  :password_confirmation => 'user2')

u.shipping_address = a3_s
u.billing_address = a3_b
u.login = 'user2'
u.save!

u = User.new(:first_name => 'Moderator', :last_name => 'Moderator',
  :email => 'nobody3@0x7a69.net', :password => 'moderator',
  :password_confirmation => 'moderator', :login => 'moderator', :role => moderator_role)

u.shipping_address = a3_s.clone
u.billing_address = a3_b.clone
u.login = 'moderator'
u.role = moderator_role
u.save!




puts "Creating categories"

Category.create!( [{:name => 'Baseball'}, {:name => 'Basketball'}, {:name => 'Football'},
    {:name => 'Hockey'}, {:name => 'Lacrosse'},
    {:name => 'Soccer'}, {:name => 'Wrestling'}, {:name => 'Other'}])

puts "Creating Teams"

Team.create!( [{:name => 'Team A', :country => 'United States'},
    {:name => 'Team B', :country => 'United States'},
    {:name => 'Team C', :country => 'United States'} ])

puts "Creating Items"

(1..10).each do |i|
  User.where(:role_id => nil).each do |u|
    c = Category.order('RAND()').first
    l = u.lockers.first
    Item.create!(:name => "Item #{i}", :category => c, :user => u, :description => "A description for item #{i}.  " * 40,
      :locker => l, :weight_lbs => rand(10).round + 1, :price => rand(100).round + 1,
      :team => Team.order('RAND()').first)
  end
end
