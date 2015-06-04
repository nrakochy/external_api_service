require 'spec_helper'

describe HTTPS_Client do
  let(:client){  HTTPS_Client.new }

  describe "#get_request" do
    let(:endpoint){ URI("https://sub.example.com/path?zipcode=60201&age=35") }

    it "makes a get request to an external endpoint" do
      stub_request(:get, endpoint)
      client.get_request(endpoint)
      expect(WebMock).to have_requested(:get, endpoint).
        with(:query => {zipcode: 60201, age: 35})
    end

    it "retries hitting the endpoint 5 times when exception is raised" do
      client.get_request(endpoint)
      expect(WebMock).to have_requested(:get, endpoint).times(5)
    end

    it "returns a Struct object with status code if requests are unsuccessful" do
      stub_request(:get, endpoint).to_raise(Exception)
      response = client.get_request(endpoint)
      expect(response.code).to eq(422)
    end
  end

  describe "#parse_response" do
    let(:sample_json){ { "propensity" => 0.26532, "ranking" => "C" }.to_json }
    let(:response){ Struct.new(:code, :body) }

    it "returns a hash with symbolized keys for successful http request" do
      data = response.new("200", sample_json)
      expect(client.parse_response(data)).to eq({ propensity: 0.26532, ranking: "C" })
    end

    it "returns a hash with error key for failed http req" do
      error = response.new(422, Exception)
      error_response = client.parse_response(error)
      expect(error_response[:error].code).to eq( 422 )
    end
  end
end
