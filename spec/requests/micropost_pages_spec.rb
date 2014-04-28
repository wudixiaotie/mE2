require 'spec_helper'

describe "Micropost pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect do
          find(:css, "section input.btn.btn-lg.btn-success").click
        end.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { find(:css, "section input.btn.btn-lg.btn-success").click }
        it { should have_content("error") }
      end
    end

    describe "with valid information" do
      before do
        find(:css, "section textarea").set("asdf")
      end
      it "should create a micropost" do
        expect do
          find(:css, "section input.btn.btn-lg.btn-success").click
        end.to change(Micropost, :count).by(1)
      end
    end

    describe "140 characters remaining" do
      it { should have_selector("span.remaining", text: "140 characters remaining") }
    end

    # describe "1 characters remaining" do
    #   before { fill_in "micropost_content", with: "a" }
    #   it { should have_selector("span.remaining", text: "139 character remaining") }
    #   it { pp find("span.remaining").text }
    # end
  end
end