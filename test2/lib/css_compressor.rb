# encoding: utf-8

require 'fileutils'

class CSSCompressor
  attr_reader :source
  
  def initialize srcpath
    @source = File.read(srcpath)
  end
  
  def compress_to destpath
    File.open(destpath, 'w'){ |file| file.write compressed_source }
  end

  def compressed_source
    incomment = false
    @source.split("\n").map do |line| 
      line.rstrip!
      
      incomment = false if line =~ /.*\*\//
      next if incomment
      
      if line =~ /\/\*.*\*\//
        line.gsub!(/\/\*.*\*\//, '')
        next if line.strip.empty?
      end

      if line =~ /\/\*.*/
        incomment = true
        line.gsub!(/\/\*.*/, '')
        next if line.empty?
      end
      
      line.gsub!(/.*\*\//, '')
      line.rstrip!
      next if line.empty?
      
      line.strip! if line =~ /\{|\}/
      line
    end.compact.join("\n")
  end
end
