require 'spec_helper'

describe UsersController do

	subject { page }

	# shared examples
	shared_examples_for 'all user pages' do

		it { should have_selector('h1', text: h1) }
		it { should have_title(full_title(page_title)) }
	end

  describe 'Sign up page' do
    before { visit signup_path }

		it_should_behave_like 'all user pages'
    let(:h1) { 'Sign up' }
    let(:page_title) { 'Sign up' }
    let(:submit) { "Create my account" }

    describe 'when input invalid info' do
    	it 'should not create a user' do
    	  expect { click_button submit }.not_to change(User, :count)
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
    end
  end

  describe 'profile page' do
  	before { visit user_path(user) }

		it_should_behave_like 'all user pages'
  	let(:user) { FactoryGirl.create(:user) }
    let(:h1) { user.name }
    let(:page_title) { user.name }
  end
end
