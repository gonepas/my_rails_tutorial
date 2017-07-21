User.create!(name: "Do Xuan Tho",
  email: "gonepas08@gmail.com",
  password: "123456789",
  password_confirmation: "123456789",
  admin: true)

99.times do |n|
  name = Faker::LeagueOfLegends.champion
  email = "example-#{n+1}@gmail.com"
  password = "123abcd"
  User.create!(name:  name,
    email: email,
    password: password,
    password_confirmation: password)
end
