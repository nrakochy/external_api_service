require 'spec_helper'

describe ExternalApiService do
  let(:formatted_uri){ URI("http://sub.example.com/path?zipcode=60201&age=35") }
  let(:formatted_https_uri){ URI("http://sub.example.com/path?zipcode=60201&age=35") }
  let(:endpoint){ "http://sub.example.com/path" }
  let(:https_endpoint){ "http://sub.example.com/path" }
  let(:query){ { zipcode: 60201, age: 35 } }

  it 'has a version number' do
    expect(ExternalApiService::VERSION).not_to be nil
  end

  it 'makes get request to http endpoint' do
    response_body = { sample_message: "success" }
    stub_request(:get, formatted_uri).to_return(:body => response_body.to_json, :status => 200)
    ExternalApiService.get_service(endpoint, query)
    expect(WebMock).to have_requested(:get, formatted_uri).
      with(:query => {zipcode: 60201, age: 35})
  end

  it 'makes get request to HTTPS endpoint' do
    response_body = { sample_message: "success" }
    stub_request(:get, formatted_https_uri).to_return(:body => response_body.to_json, :status => 200)
    ExternalApiService.get_service(https_endpoint, query)
    expect(WebMock).to have_requested(:get, formatted_uri).
      with(:query => {zipcode: 60201, age: 35})
  end


  it 'returns data from the endpoint as a Ruby hash' do
    response_body = { sample_message: "success" }
    stub_request(:get, formatted_uri).to_return(:body => response_body.to_json, :status => 200)
    expect(ExternalApiService.get_service(endpoint, query)).to eq(response_body)
  end

end
