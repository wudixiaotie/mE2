require 'spec_helper'

describe User do

  before do
    @user =  User.new(name:                  'Example_User',
                      email:                 'user@example.com',
                      password:              'foobar',
                      password_confirmation: 'foobar',
                      verified:              false)
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:verified) }
  it { should respond_to(:sign_in_token) }
  it { should respond_to(:verify_email_token) }
  it { should respond_to(:password_reset_token) }
  it { should respond_to(:password_reset_sent_at) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:followers) }
  it { should be_valid }
  it { should_not be_verified }
  it { should_not be_admin }

  # name

  describe 'when name is not present' do
    before { @user.name = ' ' }
    it { should_not be_valid }
  end

  describe 'when name is too long' do
    before { @user.name = 'a' * 51 }
    it { should_not be_valid }
  end

  describe 'when name should be unique' do
    let(:exist_user) { FactoryGirl.create(:user) }
    before { @user.name = exist_user.name }
    it { should_not be_valid }
  end

  describe 'when name should not be start with special charactor' do
    before { @user.name = "@fff" }
    it { should_not be_valid }
  end

  # email

  describe 'when email is not present' do
    before { @user.email = ' ' }
    it { should_not be_valid }
  end

  describe 'when email is too long' do
    before { @user.email = 'a' * 101 }
    it { should_not be_valid }
  end

  describe 'when email format is invalid' do
    it 'should be invalid' do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
        foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe 'when email format is valid' do
    it 'should be valid' do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp
        a+b@baz.cn oyes@dfg.dkdd.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe 'when email address is already taken' do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe 'when email upcase' do  
    let(:upcase_email) { 'ASF@DSF.COM' }

    it 'should be saved as all lower-case' do
      @user.email = upcase_email
      @user.save
      expect(@user.reload.email).to eq upcase_email.downcase
    end
  end

  # password

  describe 'with a password that\'s too short' do
    before { @user.password = @user.password_confirmation = 'a' * 5 }
    it { should_not be_valid }
  end

  describe 'return value of authenticate method' do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe 'with valid password' do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe 'with invalid password' do
      let(:user_for_invalid_password) { found_user.authenticate('invalid') }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe 'create token when create' do
    before { @user.save }
    its(:sign_in_token) { should_not be_blank }
  end

  describe "send_password_reset" do

    it "generates a unique password_reset_token each time" do
      @user.send_password_reset_email
      last_token = @user.password_reset_token
      @user.send_password_reset_email
      @user.password_reset_token.should_not eq(last_token)
    end

    it "saves the time the password reset was sent" do
      @user.send_password_reset_email
      @user.reload.password_reset_sent_at.should be_present
    end

    it "delivers email to user" do
      @user.send_password_reset_email
      last_email.to.should eq([@user.email])
      last_email.subject.should eq('Reset your password!')
    end
  end

  describe "microposts associations" do
    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should delete associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |m|
        expect(Micropost.where(id: m.id)).to be_empty
      end
    end

    describe "status" do
      let(:unfollow_micropost) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorffem ipsums") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollow_micropost) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its("followed_users"){ should include(other_user) }

    describe "and unfollowing" do
      before{ @user.unfollow!(other_user) }
      it { should_not be_following(other_user) }
      its("followed_users"){ should_not include(other_user) }
    end

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end
  end
end