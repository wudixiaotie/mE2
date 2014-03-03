FactoryGirl.define do
	factory :user do
		name	'Michael Xiao'
		email	'michael@example.com'
		password	'foobar'
		password_confirmation	'foobar'
		is_valid true
	end
end