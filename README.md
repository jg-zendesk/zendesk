# Zendesk API

Ruby bindings to the Zendesk API

## What's Supported

This is a quick and dirty implementation and it covers a very limited set of services (mostly the services involving the User resources). The `Zendesk::API` class declares which services are supported:

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


## Usage

Nothing to it:

    require 'zendesk'
    
    # create instance with credentials
    api = Zendesk::API(username: 'jane@example.com', password: 'password', deskname: 'example')
    
    # get user data
    api.get_user(id: 1) # => { "user" => { ... } }
    
    # get user data on behalf of some other user
    api.get_user(id: 1, as: 'jill@example.com') # => { "user" => { ... } }

    # add user email 
    api.post_user_email_address('jane.alternate@example.com', id: 1) # => true (if successful)
    
    # add user twitter handle
    api.post_user_twitter_handle('janestwitterhandle', id: 1) # => true (if successful)
  
Check the `/examples` directory for additional examples.
