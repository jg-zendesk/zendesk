# Test Three

Write a Ruby class that implements a letter-based grading system (A+, A, A-, ...).  The class should be able to naturally sort by the value of grade (i.e., A+ > A > A-).  The class should be constructed with a string-value for the grade.

    a_plus = Grade.new("A+")
    a      = Grade.new("A")
    a_plus > a       # should return true
    [a_plus, a].sort # should return [a, a_plus]

## Solution

The `Grade` class encapsulates the behavior as described above. It does this by assigning an internal numerical value for each grade when an instance of `Grade` is created:

Grades are restricted to the following labels: `A` to `D`, `A+` to `D+`, `A-` to `D-`, and `F` - specifiying a label outside of this set will raise an exception.

Additionally, `Grade` implements the `<=>` message using the assigned numerical values of the receiver and the argument object to compute the result. Since the `Comparable` module is included, implementation of the other comparison operators (e. g: `>`, `==`, `between?`) come for free.

## Installation and Usage

To ensure all the tests and scripts will run correctly a Gemfile is included to help install dependencies. The following command will do this for you:

    $ bundle

To run the specs:
  
    $ bundle exec rspec spec/
    
## Limitations

Tested under Ruby 1.9.3p0 revision 33570 under OS X Lion only.
