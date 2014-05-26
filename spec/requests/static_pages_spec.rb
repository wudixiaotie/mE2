require 'spec_helper'

describe StaticPagesController do

  subject { page }

  # shared examples
  shared_examples_for 'all static pages' do
    it { should have_selector('h1', text: h1) }
    it 'should redirect to root' do
      expect(page.title).to eq(full_title(page_title))
    end
  end

  describe 'Home page' do
    before { visit root_path }

    it_should_behave_like 'all static pages'
    let(:h1) { 'Welcome to the mE2' }
    let(:page_title) { '' }
    it { should_not have_title('| Home') }

    describe "for sign in user" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "ffff")
        FactoryGirl.create(:micropost, user: user, content: "fddd")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end

      describe "should have correct micropost count" do
        it { should have_selector("li", text: "2 microposts") }
        it "count should be one after delete one micropost" do
          user.microposts.first.destroy
          visit root_path
          expect(page).to have_selector("li", text: "1 micropost")
          expect { click_link "delete" }.to change(Micropost, :count).by(-1)
        end
      end

      it { should_not have_selector("ul.pagination") }

      describe "should have correct pagination" do
        before do
          55.times do
            content = Faker::Lorem.sentence(5)
            FactoryGirl.create(:micropost, user: user, content: content)
          end
          visit root_path
        end

        it { should have_selector("ul.pagination") }
        it { should have_selector("ul.pagination a", text: 1) }
        it { should have_selector("ul.pagination a", text: 2) }
        it { should have_selector("ul.pagination a", text: 3) }
        it { should_not have_selector("ul.pagination a", text: 4) }
      end

      it { should have_selector("a", text: "delete") }

      describe "should not have delete link for other user's micropost" do
        let(:another_user) { FactoryGirl.create(:user) }
        before do
          user.follow!(another_user)
          another_user.microposts.create!(content: "followed_user micropost")
          visit root_path
        end

        it { should have_selector("span.content", text: "followed_user micropost") }
        it { should_not have_xpath("//a[@title='followed_user micropost']") }
      end

      it { should have_selector("a", text: "Reply") }

      describe "should have the micropost which you reply to" do
        let(:reply_to_user) { FactoryGirl.create(:user) }
        before do
          find(:css, "section textarea").set("@#{reply_to_user.name}:asdf!")
          find(:css, "section input.btn.btn-lg.btn-success").click
        end
        it { should have_link("@#{reply_to_user.name}:") }
        it { should have_content("asdf!") }

        describe "click the link should visit reply to user's profile page" do
          before { click_link("@#{reply_to_user.name}:") }
          it { should have_title(full_title(reply_to_user.name)) }
        end

        describe "should find micropost in follower's feed page" do
          let(:follower) { FactoryGirl.create(:user) }
          before do
            follower.follow!(user)
            sign_in follower
            visit root_path
          end

          it { should have_link("@#{reply_to_user.name}:") }
          it { should have_content("asdf!") }
        end

        describe "should not find micropost in other's feed page" do
          let(:other_user) { FactoryGirl.create(:user) }
          before do
            sign_in other_user
            visit root_path
          end

          it { should_not have_link("@#{reply_to_user.name}:") }
          it { should_not have_content("asdf!") }
        end
      end

      describe "should have the micropost which somebody replies you" do
        let(:replies_user) { FactoryGirl.create(:user) }
        before do
          sign_in replies_user
          visit root_path
          find(:css, "div.modal-body textarea").set("@#{user.name}:i like you opinion!")
          find(:css, "div.modal-body input.btn.btn-lg.btn-success").click
          sign_in user
          visit root_path
        end

        it { should have_link("@#{user.name}:") }
        it { should have_link("#{replies_user.name}") }
        it { should have_content("i like you opinion!") }

        describe "click the link should visit replies user's profile page" do
          before { click_link("@#{user.name}:") }
          it { should have_title(full_title(user.name)) }
        end
      end

      describe "should have count of unread messages" do
        let(:sender) { FactoryGirl.create(:user) }
        before do
          sign_in sender
          visit messages_path
          find(:css, "#message_receiver_name").set("#{user.name}")
          find(:css, "#message_content").set("lalala")
          find(:css, "div.modal-body input.btn.btn-lg.btn-success").click
          sign_in user
          visit root_path
        end

        it { should have_selector('span.badge.alert-info.pull-right', text: '1') }
      end
    end
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
    click_link "", href: root_path
    should have_title(full_title(''))
    click_link "", href: help_path
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
