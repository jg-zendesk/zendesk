# encoding: utf-8

require "spec_helper"

describe Zendesk::API do
  let(:credentials) { { email: "jg@sogetthis.com", password: "password", domain: "sogetthis.zendesk.com" } }
  subject{ Zendesk::API.new(credentials) }
  
  it { subject.should be_an_instance_of Zendesk::API }
  it { subject.credentials == credentials }

  context "user resource" do
    it "defines GET services" do
      [ :user, :user_identities, :users, :users_in_organization, :users_in_group ].each do |resource|
        subject.should respond_to(:"get_#{resource}")
      end
    end
      
    it "defines PUT services" do
      [ :user_data ].each do |resource|
        subject.should respond_to(:"put_#{resource}")
      end
    end

    it "defines POST services" do
      [ :user_email_address, :user_twitter_handle ].each do |resource|
        subject.should respond_to(:"post_#{resource}")
      end
    end

    it "defines DELETE services" do
      [ :user, :user_identity ].each do |resource|
        subject.should respond_to(:"delete_#{resource}")
      end
    end
    
    describe "#get_user" do
      it { expect{ subject.get_user }.to raise_error(ArgumentError) }
      it { expect{ subject.get_user id: 174909853 }.to_not raise_error }
      it { expect{ subject.get_user id: 174909853, as: "support@sogetthis.com" }.to_not raise_error }
      it { subject.get_user(id: 174909853)["user"].should be_an_instance_of Hash }
      it { subject.get_user(id: 1).should be_nil }
    end

    describe "#get_user_identities" do
      it { expect{ subject.get_user_identities }.to raise_error(ArgumentError) }
      it { expect{ subject.get_user_identities id: 174909853 }.to_not raise_error }
      it { subject.get_user_identities(id: 174909853)["user_email_identities"].should be_an_instance_of Array }
      it { subject.get_user_identities(id: 174909853, as: "support@sogetthis.com").should be_nil }
    end
    
    describe "#get_users" do
      it { expect{ subject.get_users id: 1 }.to raise_error(ArgumentError) }
      it { expect{ subject.get_users }.to_not raise_error }
      it { expect{ subject.get_users as: "support@sogetthis.com" }.to_not raise_error }
      it { subject.get_users["users"].should be_an_instance_of Array }
    end

    describe "#get_users_in_organization" do
      it { expect{ subject.get_users_in_organization }.to raise_error(ArgumentError) }
      it { expect{ subject.get_users_in_organization organization_id: 21218858 }.to_not raise_error }
      it { expect{ subject.get_users_in_organization organization_id: 21218858, as: "support@sogetthis.com" }.to_not raise_error }
      it { subject.get_users_in_organization(organization_id: 21218858)["users"].should be_an_instance_of Array }
      it { subject.get_users_in_organization(organization_id: 1).should be_nil }
    end

    describe "#get_users_in_group" do
      it { expect{ subject.get_users_in_group }.to raise_error(ArgumentError) }
      it { expect{ subject.get_users_in_group group_id: 20160438 }.to_not raise_error }
      it { expect{ subject.get_users_in_group group_id: 20160438, as: "support@sogetthis.com" }.to_not raise_error }
      it { subject.get_users_in_group(group_id: 20160438)["users"].should be_an_instance_of Array }
    end
    
    describe "#put_user_data" do
      let(:data) { { remote_photo_url: "http://www.gravatar.com/avatar/2d5f093edea7d11c9716d72a0a31126e.png" }.to_xml(root: "user") }
      it { expect{ subject.put_user_data }.to raise_error(ArgumentError) }
      it { expect{ subject.put_user_data data }.to raise_error(ArgumentError) }
      it { expect{ subject.put_user_data data, id: 174909853 }.to_not raise_error }
      it { subject.put_user_data(data, id: 174909853).should be true }
      it { subject.put_user_data(data, id: 174909853, as: "support@sogetthis.com").should be false }
    end
    
    describe "#post_user_email_address" do
      it { expect{ subject.post_user_email_address }.to raise_error(ArgumentError) }
      it { expect{ subject.post_user_email_address "anotheremail@sogetthis.com" }.to raise_error(ArgumentError) }
      it { expect{ subject.post_user_email_address "anotheremail@sogetthis.com", id: 174909853 }.to_not raise_error }
    end
  end
end
