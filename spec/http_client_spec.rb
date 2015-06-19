require 'spec_helper'

describe HTTP_Client do
  let(:client){  HTTP_Client.new }
  let(:https_endpoint){ URI("https://sub.example.com/path?zipcode=60201&age=35") }
  let(:sample_get_req){ Net::HTTP::Get.new(https_endpoint) }
  let(:sample_post_req){ Net::HTTP::Post.new(https_endpoint) }


  describe "#make_request" do
    context "using HTTPS" do
      it "makes a post request to an external endpoint" do
        stub_request(:post, https_endpoint)
        client.make_request(https_endpoint, sample_post_req)
        expect(WebMock).to have_requested(:post, https_endpoint)
      end

      it "retries hitting the endpoint 5 times when exception is raised" do
        stub_request(:post, https_endpoint).to_raise(Exception)
        client.make_request(https_endpoint, sample_post_req)
        expect(WebMock).to have_requested(:post, https_endpoint).times(5)
      end

      it "returns a Struct object with status code if requests are unsuccessful" do
        stub_request(:post, https_endpoint).to_raise(Exception)
        response = client.make_request(https_endpoint, sample_post_req)
        expect(response.code).to eq(422)
      end
    end

    context "using HTTP" do
      let(:http_endpoint){ URI("http://sub.example.com/path?zipcode=60201&age=35") }
      it "makes a get request to an external endpoint" do
        stub_request(:get, http_endpoint)
        client.make_request(http_endpoint, sample_get_req)
        expect(WebMock).to have_requested(:get, http_endpoint).
          with(:query => {zipcode: 60201, age: 35})
      end

      it "retries hitting the endpoint 5 times when exception is raised" do
        stub_request(:get, https_endpoint).to_raise(Exception)
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

  describe "#build_post_request" do
    let(:http_params){
      { uri: URI("https://sample.com/"), data: {"sample_data" => "sample"},
      credentials: ["username", "samplepassword"], header_params: {} }
    }
    it "returns a NET::HTTP:Request object" do
      expect(client.build_post_request(http_params).class).to eq(Net::HTTP::Post)
    end

    it "assigns POST request content-type as 'application/json'" do
      expect(client.build_post_request(http_params)["Content-Type"]).to eq("application/json")
    end

    it "properly formats data payload as POST body" do
      expect(client.build_post_request(http_params).body).to eq({"sample_data" => "sample"}.to_json)
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
