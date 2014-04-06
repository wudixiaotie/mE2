require 'spec_helper'

describe Relationship do
  let!(:follower) { FactoryGirl.create(:user) }
  let!(:followed) { FactoryGirl.create(:user) }
  let!(:relationship) { follower.relationships.create(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }

  describe "follower methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should eq follower }
    its(:followed) { should eq followed }
  end

  describe "follower destroy" do
    it do
      relationship_array = follower.relationships.to_a
      follower.destroy
      expect(relationship_array).not_to be_empty
      relationship_array.each do |r|
        expect(Relationship.where(id: r.id)).to be_empty
      end
    end
  end

  describe "followed_user destroy" do
    it do
      relationship_array = followed.relationships.to_a
      followed.destroy
      relationship_array.each do |r|
        expect(Relationship.where(id: r.id)).to be_empty
      end
    end
  end

  describe "follower id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end

  describe "followed_id is not present" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end
end