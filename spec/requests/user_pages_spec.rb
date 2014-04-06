require 'spec_helper'

describe UsersController do

  subject { page }

  describe 'Sign up page' do
    before { visit signup_path }

    it { should have_title(full_title('Sign up')) }
    it { should have_selector('h1', text: 'Sign up') }
    it { should_not have_selector("input[type='email'][disabled='disabled']") }
    it { should have_selector("input[type='email'][placeholder='Enter email']") }
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
        fill_in 'Name',         with: 'Example User'
        fill_in 'Email',        with: 'user@example.com'
        fill_in 'Password',     with: 'foobar'
        fill_in 'Confirmation', with: 'foobar'
      end

      it 'should create a user' do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe 'after saving the user' do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(full_title('')) }
        it { expect(user.verified).to be_false }
        it { should have_content('Account created successfully!') }

        it 'should send a verify email to user email account' do
          last_email.to.should eq([user.email])
          last_email.subject.should eq('Verify your email account!')
        end
      end
    end
  end

  describe 'profile page' do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

  	before { visit user_path(user) }

    it { should have_title(full_title(user.name)) }
    it { should have_selector('h1', text: user.name) }

    describe "micropost" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end

    describe "follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the follower count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
    end
  end

  describe 'Verify email' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      user.verified = false
      user.save
      user.send_verify_email
      visit verify_email_path(user.reload.verify_email_token)
    end

    it { user.reload.verified.should be_true }
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
    let(:user) { FactoryGirl.create(:user, name: 'Miccall',
                                           email: 'miccall@example.com',
                                           password: 'foobar',
                                           password_confirmation: 'foobar') }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe 'page' do
      it { should have_title('Edit user') }
      it { should have_content('Update your profile') }
      it { should have_link('change', href: 'https://gravatar.com/emails') }
      it { should have_selector("input[type='email'][disabled='disabled']") }
      it { should_not have_selector("input[type='email'][placeholder='Enter email']") }
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
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq old_email }
    end

    describe 'set admin to true' do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end

      specify { expect(user.reload).not_to be_admin }
    end
  end

  describe 'Index page' do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      FactoryGirl.create(:user, name: 'Bob', email: 'bob@exmaple.com')
      FactoryGirl.create(:user, name: 'Tom', email: 'tom@exmaple.com')
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_title(full_title('Find user')) }
    it { should have_content('Find user') }

    it 'should have all users' do
      User.all.each do |u|
        expect(page).to have_selector('li', text: u.name)
      end
    end

    describe 'pagination' do

      before(:all) { 20.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it { should have_selector('ul.pagination') }

      it 'should list 10 users in the page' do
        User.page(1).each do |u|
          expect(page).to have_selector('li', text: u.name)
        end
      end

      it 'should not list more than 10 users in the page' do
        User.page(2).each do |u|
          expect(page).not_to have_selector('li', text: u.name)
        end
      end
    end

    describe 'delete link' do
      it { should_not have_link('delete') }

      describe 'as a admin' do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it 'should be able delete a user' do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }

        describe 'should not delete itself' do
          before do
            sign_in admin, no_capybara: true
            delete user_path(admin)
          end

          it 'should redirect to root' do
            expect(response).to redirect_to(root_url)
          end
        end
      end
    end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title("Following")) }
      it { should have_selector("h3", text: "Following") }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title("Followers")) }
      it { should have_selector("h3", text: "Followers") }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end
end
