# encoding: utf-8

require "active_support/core_ext/hash"
require 'crack'
require 'rest-client'

module Zendesk
  class API
    RequestError = Class.new(StandardError)
    
    def initialize username, password, domain
      @username = username
      @password = password
      @domain   = domain
    end

    def open_ticket description, options = { }
      options.assert_valid_keys(:ticket_type_id, :priority_id, :requester_email, :requester_name)
      payload = { ticket: options.merge(description: description) }
      resource("/tickets", with_payload: true).post(payload, &responder)
    end
    
    def get_ticket id
      ticket = resource("/tickets/#{id}").get(&responder)
      ticket["ticket"] unless ticket.nil?
    end
  
    def close_ticket id, options = { }
      options.assert_valid_keys(:assignee_id, :status_id)
      payload = { ticket: { status_id: 4 }.merge(options) }
      resource("/tickets/#{id}", with_payload: true).put(payload, &responder)
    end

    def delete_ticket id
      resource("/tickets/#{id}").delete(&responder)
    end
    
    def create_user email, name, role_id, restriction_id
      payload = { user: { email: email, name: name, roles: role_id, restriction_id: restriction_id } }
      resource("/users", with_payload: true).post(payload, &responder)
    end
   
    def delete_user id
      resource("/users/#{id}").delete(&responder)
    end
    
    def get_user id
      user = resource("/users/#{id}").get(&responder)
      user["user"] unless user.nil?
    end
     
    def get_users
      resource("/users").get(&responder)["users"]
    end

    private
    def resource path, options = { }
      options = options.reverse_merge(user: @username, password: @password)
      options.merge!(headers: { content_type: "application/xml" }) if options.delete(:with_payload)
      url = "http://#{@domain}/api/v1#{path}.xml"
      RestClient::Resource.new(url, options)
    end
    
    def responder 
      ->(response, request, result, &block) {
        case response.code
        when 200 then (response.strip.empty? ? true : Crack::XML.parse(response))
        when 201 then result['location'].split("/").last.to_i
        when 302 then response.follow_redirection(request, result, &block)
        when 404 then nil
        else raise RequestError, response
        end
      }
    end
  end
end