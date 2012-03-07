# encoding: utf-8

require "zendesk/version"

require "named-parameters"
require "rest_client"
require "crack/xml"
require "active_support/core_ext/hash"
require 'ostruct'

module Zendesk
  autoload :Base, "zendesk/base"
  autoload :API,  "zendesk/api"
end
