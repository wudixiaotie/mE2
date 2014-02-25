require 'spec_helper'

describe 'Static pages' do

  describe 'Home page' do

    it "should have the content 'mE2'" do
      visit '/static_pages/home'
      expect(page).to have_content('mE2 Home')
    end

	it "should have the right title" do
	  visit '/static_pages/home'
	  expect(page).to have_title("mE2 | Home")
	end
  end

  describe 'Help page' do

  	it "should have the content 'Help'" do
  	  visit '/static_pages/help'
  	  expect(page).to have_content('Help')
  	end

	it "should have the right title" do
	  visit '/static_pages/help'
	  expect(page).to have_title("mE2 | Help")
	end
  end

  describe 'About page' do

  	it "should have the content 'About Us" do
  		visit '/static_pages/about'
  		expect(page).to have_content('About Us')
  	end
  	
	it "should have the right title" do
	  visit '/static_pages/about'
	  expect(page).to have_title("mE2 | About Us")
	end
  end
end
