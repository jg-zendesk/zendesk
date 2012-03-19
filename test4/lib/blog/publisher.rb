# encoding: utf-8

module Blog
  module Publisher
    def self.print blog, view = DefaultView.new
      view.draw blog.header, blog.footer, blog.posts
    end
  end
end
