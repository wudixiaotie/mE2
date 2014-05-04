require 'spec_helper'

describe 'AuthenticationPages' do

  subject { page }

  describe 'signin page' do
    before { visit signin_path }

    it { should have_title('Sign in') }
    it { should have_content('Sign in') }
    it 'should have the right link' do
      click_link 'Sign up now!'
      should have_title(full_title('Sign up'))
    end

    describe 'anthentication invalid' do
      before { click_button 'Sign in' }

      it { should have_title(full_title('Sign in')) }
      it { should have_selector('div.alert.alert-danger') }
      it { should_not have_selector('a',    text: 'Settings') }
      it { should_not have_link('Sign out', href: signout_path) }
      it { should_not have_link('', href: messages_path) }

      describe 'after visiting another page' do
        before { click_link "", href: root_path }
        it { should_not have_selector('div.alert.alert-danger') }
      end
    end

    describe 'anthentication valid' do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(full_title(user.name))}
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should have_link('', href: messages_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe 'followed by signout' do
        before { click_link 'Sign out' }
        it { should have_link('Sign in') }
      end

      describe 'can\'t visit new action' do
        before { visit signup_path }
        it 'should redirect to root' do
          expect(page.title).to eq(full_title(''))
        end
      end

      describe 'can\'t visit create action' do
        let(:params) do
          { user: { name: 'ffffff',
                    email: 'fff@example.com',
                    password: user.password,
                    password_confirmation: user.password } }
        end
        before do
          sign_in user, no_capybara: true
          post users_path, params
        end
        it 'should redirect to root' do
          expect(response).to redirect_to(root_url)
        end
      end
    end

    describe 'click keep me when signed in' do
      pending 'how to test it'
    end

    describe 'user hasn\'t verify email when signed in' do
      let(:user) { FactoryGirl.create(:user) }
      before do
        user.verified = false
        user.save
        sign_in user
      end

      it { should have_title(full_title('Verify email')) }
      it { should have_selector('div.alert.alert-warning') }
      it { should have_content('Warning! Please verify your email first.') }

      describe 'click_link send verify email again' do
        before { click_button 'Resend email' }

        it 'should resend a email' do
          last_email.to.should eq([user.email])
          last_email.subject.should eq('Verify your email account!')
        end
      end
    end

    describe 'forgot my password' do
      before { click_link 'Forgotten password?' }

      it { should have_title(full_title('Reset password')) }

      describe 'click button send password reset email' do
        before { click_button 'Send email' }

        it { should have_selector('div.alert.alert-danger') }
      end

      describe 'fill uncorrect email before click button send password reset email' do
        before do
          fill_in 'Email', with: '123@user.email'
          click_button 'Send email'
        end

        it { should have_selector('div.alert.alert-danger') }
        it { should have_content('doesn\'t exist') }
      end

      describe 'fill correct email before click button send password reset email' do
        let(:user) { FactoryGirl.create(:user) }
        before do
          fill_in 'Email', with: user.email
          click_button 'Send email'
        end
        
        it { should have_selector('div.alert.alert-success') }
      end
    end
  end

  describe 'authentication' do

    describe 'for non-sign-in users' do
      let(:user) { FactoryGirl.create(:user) }

      describe "visiting the following page" do
        before { visit following_user_path(user) }
        it { should have_title("Sign in") }
      end

      describe "visiting the followers page" do
        before { visit followers_user_path(user) }
        it { should have_title("Sign in") }
      end

      describe 'visiting the user index' do
        before { visit users_path }
        it { should have_title('Sign in') }
      end

      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the delete action" do
          before { delete relationship_path(1) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe 'submitting to the update action' do
        before { patch user_path(user) }
        specify { expect(response).to redirect_to(signin_path) }
      end

      describe 'when attempt to visit a protected page' do
        before { visit edit_user_path(user) }
        it { should have_title('Sign in') }

        describe 'after sign in' do
          before { sign_in user }
          it 'should render the desired protected page' do
            expect(page).to have_title('Edit user')
          end

          describe 'resign in will redirect to profile' do
            before do
              visit about_path
              click_link 'Sign out'
              sign_in user
            end

            it { should have_title(full_title(user.name)) }
          end
        end
      end

      describe "in the Microposts controller" do
        describe "submitting to the create action" do
          before { post microposts_path }
          it { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          it { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    describe 'as wrong user' do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: 'wrong@example.com') }
      before { sign_in user, no_capybara: true }

      describe 'submitting a GET request to the Users#edit action' do
        before { get edit_user_path(wrong_user) }
        specify { expect(response.body).not_to match(full_title('Edit user')) }
        specify { expect(response).to redirect_to(root_url) }
      end

      describe 'submitting a PATCH request to the Users#update action' do
        before { patch user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_url) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end
