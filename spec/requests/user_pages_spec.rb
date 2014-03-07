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
        it { should have_content('Name can\'t be blank') }
        it { should have_content('Email can\'t be blank') }
        it { should have_content('Email is invalid') }
        it { should have_content('Password can\'t be blank') }
        it { should have_content('Password is too short (minimum is 6 characters)') }
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

        it { should have_title(full_title('')) }
        it { expect(user.is_valid).to be_false }
        it { should have_content('Account created successfully!') }

        it 'should send a verify email to user email account' do
          last_email.to.should eq([user.email])
          last_email.subject.should eq('Verify your email account!')
        end
      end
    end
  end

  describe 'profile page' do
  	before { visit user_path(user) }

  	let(:user) { FactoryGirl.create(:user) }
    it { should have_title(full_title(user.name)) }
    it { should have_selector('h1', text: user.name) }
  end

  describe 'Verify email' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      user.is_valid = false
      user.save
      user.send_verify_email
      visit verify_email_path(user.reload.verify_email_token)
    end

    it { user.reload.is_valid.should be_true }
  end

  describe 'Reset password' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      user.send_password_reset_email
      visit edit_password_reset_path(user.reload.password_reset_token)
      fill_in 'Password', with: 'abcd1234'
      fill_in 'Confirmation', with: 'abcd1234'
      click_button 'Reset password'
    end

    it { user.reload.authenticate('abcd1234').should eq(user) }
  end

  describe 'Edit page' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe 'page' do
      it { should have_title('Edit user') }
      it { should have_content('Update your profile') }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe 'with invalid information' do
      before { click_button 'Save change' }

      it { should have_content('error') }
      it { should have_selector('div.alert.alert-danger') }
    end

    describe 'with valid information' do
      let(:new_name) { 'New Name' }
      let(:old_email) { user.email }
      before do
        fill_in 'Name',         with: new_name
        fill_in "Password",     with: user.password
        fill_in "Confirmation", with: user.password
        click_button 'Save change'
      end

      it { should have_title(full_title('Sign in')) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign in', href: signin_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq old_email }
    end
  end
end
