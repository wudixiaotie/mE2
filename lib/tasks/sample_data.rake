namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "XiaoTie",
                 email: "wudixiaotie@163.com",
                 password: "foobar",
                 password_confirmation: "foobar",
                 verified: true,
                 admin: true)

    user = User.find(1)
    10.times do
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(content: content)
    end

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end