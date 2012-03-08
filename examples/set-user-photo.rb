# encoding: utf-8

require 'yaml'
begin
  require 'zendesk'
rescue LoadError
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
  require 'zendesk'
end

# create API instance with credentials
api = Zendesk::API.new(email: 'jg@sogetthis.com', password: 'password', domain: 'sogetthis.zendesk.com')

# set user photo
data = { remote_photo_url: "http://www.gravatar.com/avatar/2d5f093edea7d11c9716d72a0a31126e.png" }
puts api.put_user_data(data.to_xml(root: "user"), id: 174909853)
