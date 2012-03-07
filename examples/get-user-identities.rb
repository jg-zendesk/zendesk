# encoding: utf-8

require 'yaml'
begin
  require 'zendesk'
rescue LoadError
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  require 'zendesk'
end

# create API instance with credentials
api = Zendesk::API.new(username: 'jg@sogetthis.com', password: 'password', deskname: 'sogetthis')

# get user identities
puts api.get_user_identities(id: 174909853)

