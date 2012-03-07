# Zendesk API

Ruby bindings to the Zendesk API

## What's Supported

This is a quick and dirty implementation and it covers a very limited set of services (mostly the services involving the User resources)

The `Zendesk::API` class declares the supported services:

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

## Supporting Additional Services

To support additional services/endpoints, simply declare it in the `Zendesk::API` class; for example:

    Get :tickets, path: "/tickets/:id", :required => :id
    
- declares support for fetching a Ticket resource as described in http://www.zendesk.com/support/api/tickets.
