# encoding: utf-8

require 'spec_helper'

describe Grade do
  let(:valid_labels)    { [ "A", "B", "C", "D", "F" ] }
  let(:valid_modifiers) { [ "+", "-" ]   }
  
  context "a valid instance" do
    let(:label) { "A+" }
    subject{ Grade.new(label) }

    it { subject.should be_an_instance_of Grade }
    it { subject.label.should == label }
    it { expect{ subject.value }.to raise_error(NoMethodError) }

    context "normalizes given labels" do
      it { Grade.new("A+").label.should == "A+" }
      it { Grade.new("a+").label.should == "A+" }
      it { Grade.new("A-").label.should == "A-" }
      it { Grade.new("a-").label.should == "A-" }
      it { Grade.new("A").label.should  == "A"  }
      it { Grade.new("a").label.should  == "A"  }

      it "should remove the modifier when the grade is 'F'" do
        Grade.new("F+").label.should == "F"
        Grade.new("F").label.should  == "F"
        Grade.new("F-").label.should == "F"
      end
    end

    context "ensures labels are valid" do
      it "should allow valid labels only" do
        valid_labels.each do |label| 
          expect{ Grade.new(label) }.to_not raise_error
        end
      end
    
      it "should allow valid modifiers for valid labels only" do
        valid_modifiers.each do |modifier|
          valid_labels.each do |label| 
            expect{ Grade.new(label + modifier) }.to_not raise_error
          end
        end
      end
      
      it "should not allow invalid labels" do
        expect{ Grade.new("AA") }.to raise_error(ArgumentError)
        expect{ Grade.new("E") }.to raise_error(ArgumentError)
      end

      it "should not allow invalid modifiers" do
        expect{ Grade.new("A!") }.to raise_error(ArgumentError)
        expect{ Grade.new("E+") }.to raise_error(ArgumentError)
        expect{ Grade.new("E-") }.to raise_error(ArgumentError)
      end
    end
  end

  context "<=> operator" do
    let(:equal)   { Grade.new("A")  }
    let(:greater) { Grade.new("A+") }
    let(:lesser)  { Grade.new("A-") }
    subject{ Grade.new("A") }
      
    it { subject.should respond_to(:<=>)    }
    it { (subject <=> lesser).should  == +1 }
    it { (subject <=> equal).should   == 0  }
    it { (subject <=> greater).should == -1 }
    
    context "comparing to a non-comparable object" do
      it { (subject <=> nil).should be_nil }
      it { (subject <=> "A").should be_nil }
    end
  end
  
  context "messages for comparison operations" do
    let(:equal_grade)  { Grade.new("A")  }
    let(:higher_grade) { Grade.new("A+") }
    let(:lower_grade)  { Grade.new("A-") }
    subject{ Grade.new("A") }

    describe "#<" do
      it { subject.should respond_to(:<) }
      it { subject.should be < higher_grade }
    end

    describe "#<=" do
      it { subject.should respond_to(:<=) }
      it { subject.should be <= higher_grade }
      it { subject.should be <= equal_grade }
    end

    describe "#==" do
      it { subject.should respond_to(:==) }
      it { subject.should be == equal_grade }
    end

    describe "#>" do
      it { subject.should respond_to(:>) }
      it { subject.should be > lower_grade }
    end

    describe "#>=" do
      it { subject.should respond_to(:>=) }
      it { subject.should be >= lower_grade }
      it { subject.should be >= equal_grade }
    end

    describe "#between?" do
      it { subject.should respond_to(:between?) }
      it { subject.should be_between(lower_grade, higher_grade) }
      it { subject.should_not be_between(higher_grade, lower_grade) }
    end
  end
  
  describe "sorting" do
    let(:sorted_labels) { %w(A+ A A- B+ B B- C+ C C- D+ D D- F).reverse }
    let(:unsorted_grades) { 
      ((valid_labels - ["F"]).map{ |label|
        valid_modifiers.map{ |modifier| Grade.new(label + modifier) } +
        [ Grade.new(label) ]
      }.flatten + [ Grade.new("F") ]).shuffle
    }
    let(:sorted_grades) { unsorted_grades.sort }
    
    it { unsorted_grades.map(&:label).should_not == sorted_labels  }
    it { sorted_grades.map(&:label).should == sorted_labels }
    
    context "order" do
      let(:lowest)  { Grade.new("F")  }
      let(:highest) { Grade.new("A+") }
      
      it { sorted_grades.first.should == lowest }
      it { sorted_grades.last.should == highest }
      it { sorted_grades[1...-1].each{ |grade| grade.should be_between(lowest, highest) } }
      
      it "should be in ascending order" do
        sorted_grades.each_with_index do |grade, index|
          if index < sorted_grades.count - 1
            grade.should be < sorted_grades[index + 1] 
          else
            grade.should be == highest
          end
        end
      end
    end
  end
end
