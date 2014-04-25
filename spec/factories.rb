FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person_#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    # name	'Michael Xiao'
    # email	'michael@example.com'
    password	'foobar'
    password_confirmation	'foobar'
    verified true

    factory :admin do
      admin true
    end
  end

  factory :micropost do
    content "Lorem ipsum"
    user
  end
end