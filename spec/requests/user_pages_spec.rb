require 'spec_helper'

describe UsersController do

	subject { page }

	# shared examples
	shared_examples_for 'all user page' do
		it { should have_selector('h1', text: h1) }
		it { should have_title(full_title(page_title)) }
	end

  describe 'Sign up page' do
    before { visit signup_path }

    let(:h1) { 'Sign up' }
    let(:page_title) { 'Sign up' }
  end

  # 
end
