# encoding: utf-8

module Zendesk
  class API < Base
    format :xml
    
    get :user,                  path: "/users/:id"
    get :user_identities,       path: "/users/:id/user_identities"
    get :users,                 path: "/users"
    get :users_in_organization, path: "/organizations/:organization_id/users"
    get :users_in_group,        path: "/groups/:group_id/users"

    put :user_data,             path: "/users/:id"

    post :user_email_address,   path: "/users/:id/user_identities", transform: ->(address){ "<email>#{address}</email>" }
    post :user_twitter_handle,  path: "/users/:id/user_identities", transform: ->(handle){ "<twitter>#{handle}</twitter>" }

    delete :user,               path: "/users/:id"
    delete :user_identity,      path: "/users/:id/user_identities/:identity_id"
  end
end
