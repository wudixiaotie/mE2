namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end

  def make_users
    User.create!(name: "XiaoTie",
                 email: "wudixiaotie@163.com",
                 password: "foobar",
                 password_confirmation: "foobar",
                 verified: true,
                 admin: true)

    99.times do |n|
      name  = Faker::Name.name.gsub /\W/, "_"
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end

  def make_microposts
    user = User.find(1)
    30.times do
      content = Faker::Lorem.sentence(5)
      user.microposts.create!(content: content)
    end
  end

  def make_relationships
    users = User.all
    user  = users.first
    followed_users = users[2..50]
    followers      = users[3..40]
    followed_users.each { |followed| user.follow!(followed) }
    followers.each      { |follower| follower.follow!(user) }
  end
end