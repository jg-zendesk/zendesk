# Test Two

Write a Ruby class that opens a CSS file, and does a simple compression of it by removing all the blank lines, and lines that are only comments.

````css
    css_compressor = CSSCompressor.new(filename)
    css_compressor.compress_to(destination_filename)
````

Given file contents that look like this:

````css
    /* reset a few things */
    body {
      margin: 0;
      padding: 0;
    }

    /* for the main content div */
    #content {
      margin: 10px
    }
````

It should compress down to the following

````css
    body {
      margin: 0;
      padding: 0;
    }
    #content {
      margin: 10px
    }
````

## Solution

Compression (as described) is done using the following steps:

  1. Split the contents of the file into blocks of text using the newline (`\n`) character as delimiter.
  2. Apply a series of transforms and filters to each block.
  3. The blocks that passes through all the filters are collected and used to generate the compressed version of the file.

### What It Can and Will Do
  
  * Accomodate removal of single and multi-line comments.
  * Accomodate removal of single and multi-line comments interspersed within CSS block declarations.
  * Accomodate removal of comments anywhere in the CSS file.
  * Remove all empty lines.
  * Flush all the beginning and ending lines of a CSS block to the left, preserving the indentations within the body of the block.
  
### What It Can't or Wont Do
  
  * Generate a pretty-printed output - if a CSS block contains extra spaces to the left or between element declarations, they will not be removed.
  * Handle CSS with incorrect syntax gracefully.
  * Detect incorrect CSS syntax.

## Installation and Usage

To ensure all the tests and scripts will run correctly a Gemfile is included to help install dependencies. The following command will do this for you:

    $ bundle

To run the specs:
  
    $ bundle exec rspec spec/
    
## Limitations

Tested under Ruby 1.9.3p0 revision 33570 under OS X Lion only.
