# encoding: utf-8

class Grade
  attr_reader :label, :value
  
  include Comparable
  
  def initialize label
    raise ArgumentError unless label =~ /^([a-df])(\+|-)?$/i
    @value = ("Z".ord - $1.upcase.ord).to_f
    if $1.upcase == "F"
      @label = $1.upcase
    else
      @label = label.upcase
      @value = @value.send($2.to_sym, 0.1) unless $2.nil?    
    end
  end
  
  def <=> other
    return nil unless other.is_a? Grade
    @value <=> other.value
  end

  protected :value
end