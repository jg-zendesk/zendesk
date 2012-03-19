# encoding: utf-8

require "spec_helper"

describe Zendesk::API do
  let(:api){ Zendesk::API.new(username, password, domain) }
  let(:username) { "jg@sogetthis.com" }
  let(:password) { "password" }
  let(:domain)   { "sogetthis.zendesk.com" }
  
  context "bad credentials" do
    let(:password) { "badpassword" }
    
    it "fails to authenticate", :vcr do
      expect{ api.get_users }.to raise_error(Zendesk::API::RequestError)
    end
  end
  
  context "good credentials" do
    context "working with users" do
      describe "#get_users" do
        let(:response) { api.get_users }
      
        it "returns a list of users", :vcr do
          response.should be_an_instance_of Array
        end
      
        it "returns a non-empty list", :vcr do
          response.should_not be_empty
        end
      end
    
      describe "#create_user" do
        before { @userid = api.create_user('reka@sogetthis.com', 'reka terdik', 0, 4) } 
        after  { api.delete_user(@userid).should be true }
      
        it "creates the user record", :vcr do
          @userid.should be_an_instance_of Fixnum
        end
      
        it "fails for duplicate records", :vcr do
          expect{ api.create_user('reka@sogetthis.com', 'reka szabo', 0, 0) }.to raise_error(Zendesk::API::RequestError)
        end
      
        describe "#get_user" do
          context "non-existent" do
            let(:response) { api.get_user(-1) }
        
            it "returns nil", :vcr do
              response.should be_nil
            end
          end
      
          context "existent" do
            it "returns the correct data", :vcr do
              user = api.get_user(@userid)
              user["id"].should be == @userid
            end
          end
        end
      end
    end
    
    context "working with tickets" do
      describe "#open_ticket" do
        before { @ticketid = api.open_ticket("ticket description #{Time.now}") }
        after  { api.delete_ticket(@ticketid).should be true }
      
        it "creates the ticket record", :vcr do
          @ticketid.should be_an_instance_of Fixnum
        end
        
        describe "#close_ticket" do
          it "closes the ticket", :vcr do
            api.close_ticket(@ticketid).should be true
          end
        end
      
        describe "#get_ticket" do
          context "non-existent" do
            let(:response) { api.get_ticket(-1) }
        
            it "returns nil", :vcr do
              response.should be_nil
            end
          end
      
          context "existent" do
            it "returns the correct data", :vcr do
              ticket = api.get_ticket(@ticketid)
              ticket["nice_id"].should be == @ticketid
            end
          end
        end
      end
    end
  end
end