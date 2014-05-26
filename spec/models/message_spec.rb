require 'spec_helper'

describe Message do
  let(:user) { FactoryGirl.create(:user) }
  let(:receive_user) { FactoryGirl.create(:user) }
  before { @message = user.messages_sended.build(content: "I like you very much",
                                                 receiver_name: receive_user.name) }

  subject { @message }

  it { should respond_to(:content) }
  it { should respond_to(:sender_name) }
  it { should respond_to(:receiver_name) }
  it { should respond_to(:sender) }
  it { should respond_to(:receiver) }
  its(:sender) { should eq user }
  its(:receiver) { should eq receive_user }

  describe "when sender_name isn't persent" do
    before { @message.sender_name = nil }
    it { should_not be_valid }
  end
  
  describe "when receiver_name isn't persent" do
    before { @message.receiver_name = nil }
    it { should_not be_valid }
  end

  describe "with blank content" do
    before { @message.content = nil }
    it { should_not be_valid }
  end

  describe "when content is too long" do
    before { @message.content = "a" * 150 }
    it { should_not be_valid }
  end
end