# encoding: utf-8

require "zendesk"
require "vcr"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each{ |f| require f }
