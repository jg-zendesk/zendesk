# encoding: utf-8

module Blog
  class Post 
    attr_accessor :title, :comments, :created_at
   
    def self.create options = { }
      options.assert_valid_keys(:title, :comments, :created_at)
      title, comments = options.values_at(:title, :comments)
      new(title, comments, options.slice(:created_at))
    end
    
    def initialize title, comments, options = { }
      @title      = title || ''
      @comments   = Array.wrap(comments).flatten
      @created_at = options[:created_at] || Time.now
    end
  end
end
