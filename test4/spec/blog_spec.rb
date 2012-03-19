# encoding: utf-8

require 'spec_helper'

describe Blog::Blog do
  describe "#header and #footer" do
    context "when specified in options" do
      subject { Blog.create(header: "header", footer: "footer") }
      it { subject.header.should == "header" }
      it { subject.footer.should == "footer" }
    end
    
    context "when not specified in options" do
      subject { Blog.create }
      it { subject.header.should be_blank }
      it { subject.footer.should be_blank }
    end
  end
  
  describe "#submit" do
    subject { Blog.create }
    
    it { expect{ subject.submit(nil) }.to raise_error(ArgumentError) }
    it { expect{ subject.submit(Hash.new) }.to_not raise_error(ArgumentError) }
    it { expect{ subject.submit(Blog::Post.create) }.to_not raise_error(ArgumentError) }

    context "when successful" do
      subject { Blog.create }
      before { subject.submit(title: "lorem ipsum") }
      it { subject.should have(1).posts }
    end
  end
end

