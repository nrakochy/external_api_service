require 'spec_helper'

describe ExternalApiService do
  let(:endpoint){ URI("http://sub.example.com/path?zipcode=60201&age=35") }

  it 'has a version number' do
    expect(ExternalApiService::VERSION).not_to be nil
  end

  it 'makes get request to given endpoint' do
    stub_request(:get, endpoint)
    ExternalApiService.get_service(endpoint)
    expect(WebMock).to have_requested(:get, endpoint).
      with(:query => {zipcode: 60201, age: 35})
  end
end
