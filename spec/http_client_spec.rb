require 'spec_helper'

describe HTTP_Client do
  let(:client){  HTTP_Client.new }
  let(:endpoint){ URI("https://sub.example.com/path?zipcode=60201&age=35") }
  let(:http_endpoint){ URI("http://sub.example.com/path?zipcode=60201&age=35") }
  let(:sample_get_req){ Net::HTTP::Get.new(endpoint) }
  let(:sample_post_req){ Net::HTTP::Post.new(endpoint) }


  describe "#make_request" do
    context "using HTTPS" do
      it "makes a post request to an external endpoint" do
        stub_request(:post, endpoint)
        client.make_request(endpoint, sample_post_req)
        expect(WebMock).to have_requested(:post, endpoint).
          with(:query => {zipcode: 60201, age: 35})
      end

      it "retries hitting the endpoint 5 times when exception is raised" do
        stub_request(:post, endpoint).to_raise(Exception)
        client.make_request(endpoint, sample_post_req)
        expect(WebMock).to have_requested(:post, endpoint).times(5)
      end

      it "returns a Struct object with status code if requests are unsuccessful" do
        stub_request(:post, endpoint).to_raise(Exception)
        response = client.make_request(endpoint, sample_post_req)
        expect(response.code).to eq(422)
      end
    end

    context "using HTTP" do
      it "makes a get request to an external endpoint" do
        stub_request(:get, http_endpoint)
        client.make_request(http_endpoint, sample_get_req)
        expect(WebMock).to have_requested(:get, http_endpoint).
          with(:query => {zipcode: 60201, age: 35})
      end

      it "retries hitting the endpoint 5 times when exception is raised" do
        client.make_request(http_endpoint, sample_get_req)
        expect(WebMock).to have_requested(:get, http_endpoint).times(5)
      end

      it "returns a Struct object with status code if requests are unsuccessful" do
        stub_request(:get, http_endpoint).to_raise(Exception)
        response = client.make_request(http_endpoint, sample_get_req)
        expect(response.code).to eq(422)
      end
    end
  end

  describe "#parse_response" do
    let(:sample_json){ { "propensity" => 0.26532, "ranking" => "C" }.to_json }
    let(:response){ Struct.new(:code, :body) }

    it "returns a hash with symbolized keys for successful GET http request" do
      data = response.new("200", sample_json)
      expect(client.parse_response(data)).to eq({ propensity: 0.26532, ranking: "C" })
    end

    it "returns a hash with symbolized keys for successful GET http request" do
      data = response.new("204", sample_json)
      expect(client.parse_response(data)).to eq({ propensity: 0.26532, ranking: "C" })
    end


    it "returns a hash with error key for failed http req" do
      error = response.new(422, Exception)
      error_response = client.parse_response(error)
      expect(error_response[:error].code).to eq( 422 )
    end
  end
end
