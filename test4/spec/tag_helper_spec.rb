# encoding: utf-8

require 'spec_helper'

describe Blog::TagHelper do
  class MixedInWithTagHelper
    include Blog::TagHelper
  end
  
  context "valid instance" do
    let(:text) { "lorem ipsum dolor" }
    subject{ MixedInWithTagHelper.new }

    it { subject.html_tag(:div, text).should == "<div>#{text}</div>" }
  end
end
