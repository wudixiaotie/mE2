require 'spec_helper'

describe UsersController do

	subject { page }

  describe 'Sign up page' do
    before { visit signup_path }

    it { should have_title(full_title('Sign up')) }
    it { should have_selector('h1', text: 'Sign up') }
    let(:submit) { "Create my account" }

    describe 'when input invalid info' do
    	it 'should not create a user' do
    	  expect { click_button submit }.not_to change(User, :count)
      end

      describe 'after submission' do
        before { click_button submit }

        it { should have_title(full_title('Sign up')) }
        it { should have_content('Sign up') }
        it { should have_content('* Name can\'t be blank') }
        it { should have_content('* Email can\'t be blank') }
        it { should have_content('* Email is invalid') }
        it { should have_content('* Password can\'t be blank') }
        it { should have_content('* Password is too short (minimum is 6 characters)') }
      end
    end

	  describe 'when input valid info' do	  	
      before do
    	  fill_in 'Name', 				with: 'Example User'
    	  fill_in 'Email',				with: 'user@example.com'
    	  fill_in 'Password', 		with: 'foobar'
    	  fill_in 'Confirmation', with: 'foobar'
    	end

      it 'should create a user' do
    	  expect { click_button submit }.to change(User, :count).by(1)
    	end

      describe 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe 'profile page' do
  	before { visit user_path(user) }

  	let(:user) { FactoryGirl.create(:user) }
    it { should have_title(full_title(user.name)) }
    it { should have_selector('h1', text: user.name) }
  end
end
