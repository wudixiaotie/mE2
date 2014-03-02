require 'spec_helper'

describe StaticPagesController do

  subject { page }

  # shared examples
  shared_examples_for 'all static pages' do
    it { should have_selector('h1', text: h1) }
    it { should have_title(full_title(page_title)) }
  end

  describe 'Home page' do
    before { visit root_path }

    it_should_behave_like 'all static pages'
    let(:h1) { 'Welcome to the mE2' }
    let(:page_title) { '' }
    it { should_not have_title('| Home') }
  end

  describe 'Help page' do
    before { visit help_path }

    it_should_behave_like 'all static pages'
    let(:h1) { 'Help' }
    let(:page_title) { 'Help' }
  end

  describe 'About page' do
    before { visit about_path }

    it_should_behave_like 'all static pages'
    let(:h1) { 'About us' }
    let(:page_title) { 'About us' }
  end

  describe 'Contact page' do
    before { visit contact_path }

    it_should_behave_like 'all static pages'
    let(:h1) { 'Contact' }
    let(:page_title) { 'Contact' }
  end

  # test link
  it 'should have the right links on the layout' do

    subject { page }

    visit root_path

    click_link 'mE2'
    should have_title(full_title(''))
    click_link 'Home'
    should have_title(full_title(''))
    click_link 'Help'
    should have_title(full_title('Help'))
    click_link 'Sign in'
    should have_title(full_title('Sign in'))
    click_link 'Sign up now!'
    should have_title(full_title('Sign up'))
    click_link 'About'
    should have_title(full_title('About'))
    click_link 'Contact'
    should have_title(full_title('Contact'))
  end
end
