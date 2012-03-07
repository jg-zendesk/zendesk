# encoding: utf-8

module Zendesk
  class API < Base
    format :xml
    
    Get :user,                  path: "/users/:id", :required => :id
    Get :user_identities,       path: "/users/:id/user_identities", :required => :id
    Get :users,                 path: "/users"
    Get :users_in_organization, path: "/organizations/:organization_id/users", :required => :organization_id
    Get :users_in_group,        path: "/groups/:group_id/users", :required => :group_id

    Put :user_data,             path: "/users/:id", :required => :id

    Post :user_email_address,   path: "/users/:id/user_identities", :required => :id, transform: ->(address){ "<email>#{address}</email>" }
    Post :user_twitter_handle,  path: "/users/:id/user_identities", :required => :id, transform: ->(handle){ "<twitter>#{handle}</twitter>" }

    Delete :user,               path: "/users/:id", :required => :id
    Delete :user_identity,      path: "/users/:id/user_identities/:identity_id", :required => [ :id, :identity_id ]
  end
end