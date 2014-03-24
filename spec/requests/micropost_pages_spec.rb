require 'spec_helper'

describe "Micropost pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content("error") }
      end
    end

    describe "with valid information" do
      before { fill_in "micropost_content", with: "asdf" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end

    describe "140 characters remaining" do
      it { should have_selector("span.remaining", text: "140 characters remaining") }
    end

    # describe "1 characters remaining" do
    #   before { fill_in "micropost_content", with: "a" * 139 }
    #   it { should have_selector("span.remaining", text: "1 character remaining") }
    # end
  end
end