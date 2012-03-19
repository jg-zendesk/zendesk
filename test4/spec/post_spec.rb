# encoding: utf-8

require 'spec_helper'

describe Blog::Post do
  describe "::create" do
    context "using empty data" do
      let(:data) { Hash.new }
      subject{ Blog::Post.create data }
      it { subject.title.should_not be_nil }
      it { subject.title.should be_empty }
      it { subject.comments.should be_empty }
    end

    context "using data without title and comments' value is a String" do
      let(:data) { { comments: 'lorem ipsum dolor' } }
      subject{ Blog::Post.create data }
      it { subject.comments.should_not be_empty }
    end

    context "using data without title and comments' value is an Array" do
      let(:data) { { comments: [ 'lorem ipsum dolor' ] } }
      subject{ Blog::Post.create data }
      it { subject.comments.should_not be_empty }
    end

    context "using data without title and comments' value is a nested Array" do
      let(:data) { { comments: [ 'lorem ipsum dolor', [ 'lorem ipsum dolor' ] ] } }
      subject{ Blog::Post.create data }
      it { subject.comments.should_not be_empty }
      it { subject.comments.each{ |comment| comment.should be_an_instance_of String } }
    end

    context "using data with title only" do
      let(:data) { { title: 'lorem ipsum dolor' } }
      subject{ Blog::Post.create data }
      it { subject.title.should_not be_empty }
    end
  end
end
