# encoding: utf-8

module Blog
  module TagHelper
    def html_tag tag, text
      "<#{tag}>#{text}</#{tag}>"
    end
  end
end
