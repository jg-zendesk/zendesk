# encoding: utf-8

require "spec_helper"

describe CSSCompressor do
  let(:expected) { File.read("fixtures/expected.css") }
  before{ subject.source.should_not == expected }
  
  context "compressing the source file" do
    describe "case 1" do
      subject{ CSSCompressor.new("fixtures/case1.css") }
      it { subject.compressed_source.should == expected }
    end

    describe "case 2" do
      subject{ CSSCompressor.new("fixtures/case2.css") }
      it { subject.compressed_source.should == expected }
    end

    describe "case 3" do
      subject{ CSSCompressor.new("fixtures/case3.css") }
      it { subject.compressed_source.should == expected }
    end

    describe "case 4" do
      subject{ CSSCompressor.new("fixtures/case4.css") }
      it { subject.compressed_source.should == expected }
    end

    describe "case 5" do
      subject{ CSSCompressor.new("fixtures/case5.css") }
      it { subject.compressed_source.should == expected }
    end

    describe "case 6" do
      subject{ CSSCompressor.new("fixtures/case6.css") }
      it { subject.compressed_source.should == expected }
    end

    describe "case 7" do
      subject{ CSSCompressor.new("fixtures/case7.css") }
      it { subject.compressed_source.should == expected }
    end
  end

  describe "#compress_to" do
    let(:destpath)   { "compressed.css" }
    let(:compressed) { File.read destpath }
    
    subject{ CSSCompressor.new("fixtures/case1.css") }
    
    before do 
      FakeFS.activate!
      subject.compress_to destpath 
    end
    
    after do
      FakeFS::FileSystem.clear
      FakeFS.deactivate!
    end
    
    it { subject.source == compressed.should  }
  end
end
