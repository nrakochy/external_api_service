[![Build Status](https://travis-ci.org/nrakochy/external_api_service.svg?branch=master)](https://travis-ci.org/nrakochy/external_api_service.svg?branch=master)
[![Coverage Status](https://coveralls.io/repos/nrakochy/external_api_service/badge.svg?branch=master)](https://coveralls.io/r/nrakochy/external_api_service?branch=master)
[![Gem Version](https://badge.fury.io/rb/external_api_service.svg)](http://badge.fury.io/rb/external_api_service)

# ExternalApiService

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'external_api_service'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install external_api_service

## Usage
To use, you need to require the service module wherever you are wanting to use it:

    require ‘ExternalApiService’

### GET
To make a GET request, you need an endpoint (required), and any query params in a Hash (optional). The endpoint must return `JSON`.
It will work with `HTTPS` or `HTTP`. Call `get_service`:

    # no params
    url = 'https://data.cityofchicago.org/resource/dip3-ud6z.json'
    ExternalApiService.get_service(url)

    # with params
    url = “https://my.endpoint/path”
    params = { sample_category: “sample_category_name” }
    ExternalApiService.get_service(url, params)

`get_service` will transform the JSON to Ruby Hash with symbolized names:

    # First entry from the Chicago Problem Landlord List in Array of Hashes ('https://data.cityofchicago.org/resource/dip3-ud6z.json')

    [{:respondent=>”Ravine Properties, LLC”, :secondary_address=>”5849 W ARTHINGTON ST”,
    :location=>{:needs_recoding=>false, :longitude=>”-87.7716557532”, :latitude=>”41.8690630014”},
    :census_tracts=>”17031831400”, :census_blocks=>”170318314002042”, :x_coordinate=>”1137233.9789750562”,
    :street_block_id=>”7445”, :ward=>”29”, :address=>”1001 S MAYFIELD AVE”, :y_coordinate=>”1895377.068646989”,
    :community_area=>”AUSTIN”, :longitude=>”-87.7716557532”, :latitude=>”41.8690630014”, :community_area_number=>”25”}]

### POST
To make a POST request, you need an endpoint (required), the data you want to post, and authentication. Right now it only supports basic auth.  
The endpoint must accept and return `JSON`.

There is a header param available, but it is optional, and `Net/HTTP` handles most of it behind the scenes.


  #example: Add a subscriber to your Mailchimp Account (Api V3)
  auth = {'api_key': '123key'}
  optional_header = {}
  data_to_post: {'email' => 'example.email@example.com', 'status' => 'subscribed'}
  endpoint = 'https://us9.api.mailchimp.com/3.0/lists/123uniquelistID/members'
  ExternalApiService.post_service(endpoint, data_to_post, auth, optional_header)

Note:
You have to have the trailing '/' for the path for Ruby to POST properly e.g. http://sample.com/ (I think)

`post_service` will return the body of the response in a Ruby hash with symbolized keys.

## Sandbox
If you want to fire it up, you can run `bin/console` from the command line to launch it. You still need  `require ExternalApiService`,
but you can see it in action.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/external_api_service/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
