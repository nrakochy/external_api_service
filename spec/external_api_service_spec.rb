require 'spec_helper'

describe ExternalApiService do
  it 'has a version number' do
    expect(ExternalApiService::VERSION).not_to be nil
  end

  describe ".get_service" do
    let(:formatted_uri){ URI("http://sub.example.com/path?zipcode=60201&age=35") }
    let(:endpoint){ "http://sub.example.com/path" }
    let(:query){ { zipcode: 60201, age: 35 } }


    it 'makes get request to http endpoint' do
      response_body = { sample_message: "success" }
      stub_request(:get, formatted_uri).to_return(:body => response_body.to_json, :status => 200)
      ExternalApiService.get_service(endpoint, query)
      expect(WebMock).to have_requested(:get, formatted_uri).
        with(:query => {zipcode: 60201, age: 35})
    end

    it 'makes get request to HTTPS endpoint' do
      https_endpoint =  "http://sub.example.com/path"
      formatted_https_uri =  URI("http://sub.example.com/path?zipcode=60201&age=35")
      response_body = { sample_message: "success" }
      stub_request(:get, formatted_https_uri).to_return(:body => response_body.to_json, :status => 200)
      ExternalApiService.get_service(https_endpoint, query)
      expect(WebMock).to have_requested(:get, formatted_https_uri).
        with(:query => {zipcode: 60201, age: 35})
    end


    it 'returns data from the endpoint as a Ruby hash' do
      response_body = { sample_message: "success" }
      stub_request(:get, formatted_uri).to_return(:body => response_body.to_json, :status => 200)
      expect(ExternalApiService.get_service(endpoint, query)).to eq(response_body)
    end
  end

  describe ".post_service" do
    it 'makes post request to HTTPS endpoint' do
      url =  "http://sub.example.com/api/"
      data_to_post = {sample_data: "sample"}
      credentials = {"username" => "password"}
      response_body = { sample_message: "success" }
      stub_request(:post, "http://username:password@sub.example.com/api/").
        with(:body => "{\"sample_data\":\"sample\"}",
             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'Host'=>'sub.example.com', 'User-Agent'=>'Ruby'}).
        to_return(:status => 204, :body => response_body.to_json, :headers => {})
      expect(ExternalApiService.post_service(url, data_to_post, credentials)).to eq({sample_message: "success"})
    end
  end
end
