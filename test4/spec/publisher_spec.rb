# encoding: utf-8

require "spec_helper"

describe Blog::Publisher do
  describe "default rendering" do
    context "when all fields are bank" do
      let(:blog) { Blog.create }
      it{ subject.print(blog).should be_empty }
    end

    context "when post title is blank" do
      let(:output) { "<div>Comment1</div>\n" }
      let(:post) { { comments: "Comment1" } }
      let(:blog) { Blog.create }
      before{ blog.submit post }
      it{ subject.print(blog).should == output }
    end

    context "when post comment is blank or empty" do
      let(:output) { "<div><p>TITLE</p></div>\n" }
      let(:post) { { title: "Title" } }
      let(:blog) { Blog.create }
      before{ blog.submit post }
      it{ subject.print(blog).should == output }
    end

    context "when header is empty" do
      let(:output) { "<div><p>TITLE</p></div>\n<div>Footer</div>\n" }
      let(:post) { { title: "Title" } }
      let(:blog) { Blog.create(footer: "Footer") }
      before{ blog.submit post }
      it{ subject.print(blog).should == output }
    end

    context "when footer is empty" do
      let(:output) { "<div><h1>Header</h1></div>\n<div><p>TITLE</p></div>\n" }
      let(:post) { { title: "Title" } }
      let(:blog) { Blog.create(header: "Header") }
      before{ blog.submit post }
      it{ subject.print(blog).should == output }
    end

    context "when there is only one blog post" do
      let(:output) { @output }
      let(:post) { { title: "Title", comments: [ "Comment1", "Comment2" ] } }
      let(:blog) { Blog.create(header: "Header", footer: "Footer") }
      
      before do
        @output = <<-EOS.gsub(/^ +/, '')
          <div><h1>Header</h1></div>
          <div><p>TITLE</p></div>
          <div>Comment1</div>
          <div>Comment2</div>
          <div>Footer</div>
        EOS
        blog.submit post 
      end
      
      it{ subject.print(blog).should == output }
    end

    context "when there are many blog post" do
      let(:output) { @output }
      let(:data)  { { comments: [ "Comment1", "Comment2" ] } }
      let(:posts) { Array.new(3){ |index| Blog::Post.create(data.merge(title: "Title#{index + 1}")) } }
      let(:blog)  { Blog.create(header: "Header", footer: "Footer") }

      before do 
        @output = <<-EOS.gsub(/^ +/, '')
          <div><h1>Header</h1></div>
          <div><p>TITLE1</p></div>
          <div>Comment1</div>
          <div>Comment2</div>
          <div><p>TITLE2</p></div>
          <div>Comment1</div>
          <div>Comment2</div>
          <div><p>TITLE3</p></div>
          <div>Comment1</div>
          <div>Comment2</div>
          <div>Footer</div>
        EOS
        posts.each{ |post| blog.submit post }
      end
      
      it{ subject.print(blog).should == output }
    end
  end
  
  describe "custom rendering" do
    class CustomView
      def draw header, footer, posts
        header + "\n" + posts.map{ |post| post.title }.join("\n") + "\n" + footer
      end
    end

    let(:output) { "Header\nTitle\nFooter" }
    let(:post) { Blog::Post.create(title: "Title", comments: [ "Comment1", "Comment2" ]) }
    let(:view) { CustomView.new }
    let(:blog) { Blog.create(header: "Header", footer: "Footer") }

    before{ blog.submit post }
    it{ subject.print(blog, view).should == output }
  end
end
