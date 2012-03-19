# Test Four

Refactoring. Your task is to take the following code and make it easy to read and easy to extend. You'll want to fix as many syntactic problems as possible while altering the final output as little as possible. 

The original code is at `bin/script.v1` of this project.

## Solution

There were many issues in the original script, here are the highlights:

  * Too many responsibilites assigned to a single class.
  * Unnecesary states are kept (e. g.: `current_post`)
  * Unnecessary methods and attribute declarations.
  * Unnecessary and awkward usage of Ruby's language facilities.
  * Unnecessary remapping of options.
  * Similar methods exists and could be generalized (e. g.: `htmlDiv` and `htmlH1`)
  * Rendering of the blog and its content is fixed/hard-coded.
  * No test coverage.
  * Bad code layout.

At least one bug was found:

  * The `render_comments` method does not behave as intended.

But since there were no tests, I'm not sure if it's actually a bug. 
Or if it's the only one. 

Here are the highlights of the refactoring:

  * The `Blog` was decomposed into several classes, each designed to encapsulate a specific behavior and responsibility.
  * A namespace was introduced to group these new set of classes into a cohesive unit.
  * The concept of a view is introduced to manage rendering of the blog and its content. 
  * A default view is implemented to mimic the original scripts output (with a bug fix). Custom views may be supplied by clients of the library.
  * A `Publisher` module is introduced to act as an interface when a blog needs to be published/printed.
  * A `TagHelper` module provides utility methods related to rendering a view. Custom view implementations may choose not to use it - they only need to implement a `#draw` method that takes the `header`, `footer`, and list of `blogs` as arguments.
  * Improved test coverage.
  * Improved code layout.
  * BUGFIX: comments are now rendered as expected.

Additionally, the script file was rewritten to take advantage of these new set of classes (see: `bin/script.v2`).

## Installation and Usage

To ensure all the tests and scripts will run correctly a Gemfile is included to help install dependencies. The following command will do this for you:

    $ bundle

To run the specs:
  
    $ bundle exec rspec spec/
    
## Limitations

Tested under Ruby 1.9.3p0 revision 33570 under OS X Lion only.
