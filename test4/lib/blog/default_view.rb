# encoding: utf-8

module Blog
  class DefaultView
    include TagHelper
    
    def draw header, footer, posts
      # prepare page for rendering
      content :clear
      
      # render header
      content html_tag(:div, html_tag(:h1, header)) unless header.blank?
      
      # render post title and comments
      posts.sort_by(&:created_at).each do |post|
        content html_tag(:div, html_tag(:p, post.title.upcase)) unless post.title.blank?
        post.comments.each do |comment|
          content html_tag(:div, comment) unless comment.blank?
        end
      end
      
      # render footer
      content html_tag(:div, footer) unless footer.blank?
      
      # render page content
      content :flush
    end
    
    private
    def content text_or_directive
      case text_or_directive
      when :clear then @content = ""
      when :flush  then @content
      when String then @content.concat(text_or_directive).concat("\n")
      end
    end
  end
end
