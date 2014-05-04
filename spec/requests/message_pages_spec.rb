require 'spec_helper'

describe "Message Pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "message creation" do
    before do
      visit messages_path
      click_button "Send Message"
    end

    describe "with invalid information" do

      it "should not create a message" do
        expect do
          find(:css, "div.modal-body input.btn.btn-lg.btn-success").click
        end.not_to change(Message, :count)
      end

      describe "error messages" do
        before { find(:css, "div.modal-body input.btn.btn-lg.btn-success").click }
        it { should have_content("error") }
      end
    end

    describe "with valid information" do
      let(:receive_user) { FactoryGirl.create(:user) }
      before do
        find(:css, "div.modal-body input").set(receive_user.name)
        find(:css, "div.modal-body textarea").set("asdf")
      end
      it "should create a message" do
        expect do
          find(:css, "div.modal-body input.btn.btn-lg.btn-success").click
        end.to change(Message, :count).by(1)
      end
    end

    describe "140 characters remaining" do
      it do
        should have_selector("div.modal-body span.remaining", 
                             text: "140 characters remaining")
      end
    end
  end

  describe "message delete" do
    let(:receive_user) { FactoryGirl.create(:user) }
    before do
      user.messages_sended.create!(content: "ffff", receiver_id: receive_user.id)
      visit messages_path
    end
  end
end