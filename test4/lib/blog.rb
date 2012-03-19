# encoding: utf-8

require "active_support/core_ext/array"
require "active_support/core_ext/hash"
require "active_support/core_ext/object"

module Blog
  autoload :Post,        "blog/post"
  autoload :Publisher,   "blog/publisher"
  autoload :DefaultView, "blog/default_view"
  autoload :TagHelper,   "blog/tag_helper"

  def self.create options = { }
    options.assert_valid_keys(:header, :footer)
    Blog.new(options)
  end
  
  class Blog
    attr_reader :posts
    
    def initialize options = { }
      @options = options.reverse_merge(header: nil, footer: nil)
      @posts   = [ ]
    end
    
    def submit post_or_hash
      @posts << case post_or_hash
      when Hash then Post.create(post_or_hash)
      when Post then post_or_hash
      else raise ArgumentError
      end
    end
    
    def method_missing name, *args
      super(name, *args) unless args.empty? && @options.has_key?(name)
      @options[name]
    end
  end
end
