require 'spec_helper'

describe "AuthenticationPages" do

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

			describe 'after visiting another page' do
				before { click_link 'Home' }
				it { should_not have_selector('div.alert.alert-danger') }
			end
		end

		describe 'anthentication valid' do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in 'Email',    with: user.email
				fill_in 'Password', with: user.password
				click_button 'Sign in'
			end

			it { should have_title(full_title(user.name))}
			it { should have_link('Profile',     href: user_path(user)) }
			it { should have_link('Sign out',    href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }

			describe 'followed by signout' do
				before { click_link 'Sign out' }
				it { should have_link('Sign in') }
			end
		end

		describe 'click keep me when signed in' do
			pending 'how to test it'
		end

		describe 'user hasn\'t verify email when signed in' do
			let(:user) { FactoryGirl.create(:user) }
			before do
				user.is_valid = false
				user.save
				fill_in 'Email',    with: user.email
				fill_in 'Password', with: user.password
				click_button 'Sign in'
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
end
