## Test One

Using your favorite REST client library (e.g. https://github.com/technoweenie/faraday) write a Zendesk API client that:

1. Creates a user
2. Creates a ticket with that user as requester
3. Marks that ticket as solved

You can create a Zendesk account by signing up at http://www.zendesk.com/

There is more information about the Zendesk API available here: http://www.zendesk.com/api/ and the documentation specifically for the REST interface: http://www.zendesk.com/api/rest-introduction

## Solution

The `Zendesk::API` class is a very simple implementation of a small subset of Zendesk's API. 

The script file `bin/zendesk` performs the task described above. While the specs provides some tests against the implemented API calls required to perform the task.

## Installation and Usage

To ensure all the tests and scripts will run correctly a Gemfile is included to help install dependencies. The following command will do this for you:

    $ bundle

To run the specs:
  
    $ bundle exec rspec spec/
    
## Limitations

Tested under Ruby 1.9.3p0 revision 33570 under OS X Lion only.

## Caveats

The tests for this solution are based on the documentation referenced at http://www.zendesk.com/api/ and http://www.zendesk.com/api/rest-introduction 

At the time of this writing, there were issues when accessing the API (see: https://gist.github.com/2a80bdf0caeb1e0f613a)

Each of the invocation fails even though it looks like the request met all the requirements. 

The first one fails with an HTTP response code 500 and no explanation, so it could be on the server side. The next two fails with HTTP Response Code 406 - the error messages indicate that there are missing fields on the request even though they are provided. 
