# Zendesk API

Ruby bindings to the Zendesk API

## What's Supported

This is a quick and dirty implementation and it covers a very limited set of services (mostly the services involving the User resources). The `Zendesk::API` class declares which services are supported:

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

## Supporting Additional Services

To support additional services/endpoints, simply declare it in the `Zendesk::API` class:

    get :ticket, path: "/tickets/:id"
    
The line of code above declares support for fetching a Ticket resource as described in http://www.zendesk.com/support/api/tickets and will generate an implementation for `Zendesk::API#get_ticket options = { }` automatically enforcing that it requires a parameter named `:id` on invocation, e. g.:

    api.get_ticket          # => ArgumentError, requires :id
    api.get_ticket id: 1    # => { "ticket" => { ... } }

## Usage

Nothing to it:

    require 'zendesk'
    
    # create instance with credentials (see "Configuration, below")
    api = Zendesk::API(email: 'jane@example.com', password: 'password', domain: 'example.zendesk.com')
    
    # get user data
    api.get_user(id: 1) # => { "user" => { ... } }
    
    # get user data on behalf of some other user
    api.get_user(id: 1, as: 'jill@example.com') # => { "user" => { ... } }

    # add user email 
    api.post_user_email_address('jane.alternate@example.com', id: 1) # => true (if successful)
    
    # add user twitter handle
    api.post_user_twitter_handle('janestwitterhandle', id: 1) # => true (if successful)
  
Check the `/examples` directory for additional usage samples.

## Configuration

This gem will look in the following places, in order, for configuration information:

  - `:email`, `:password`, and `:domain`, passed directly to `Zendesk::API`
  - The `ZENDESK_EMAIL`, `ZENDESK_PASSWORD`, and `ZENDESK_DOMAIN` environment variables
  - `'email'`, `'password'`, and `'domain'` values in `{current_working_directory}/.zendesk.yml`
  - `'email'`, `'password'`, and `'domain'` values in `~/.zendesk.yml`
