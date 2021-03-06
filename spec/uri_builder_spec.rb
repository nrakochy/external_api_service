require 'spec_helper'

describe URI_Builder do

  describe ".build_uri" do
    it "converts a url string to a URI object with accessible URI attributes" do
      sample_url = "http://sub.example.com/google"
      empty_query = {}
      uri = URI_Builder.build_uri(sample_url, empty_query)
      expect(uri.class).to eq(URI::HTTP)
      expect(uri.path).to eq("/google")
      expect(uri.host).to eq("sub.example.com")
      expect(uri.scheme).to eq("http")
    end

    it "adds any given params to the uri" do
      sample_url = "http://sub.example.com/google"
      params = { sample_zip: "60201", sample_age: 35 }
      uri = URI_Builder.build_uri(sample_url, params)
      expect(uri.query).to eq("sample_zip=60201&sample_age=35")
    end

  end
end
