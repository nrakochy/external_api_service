require 'net/http'
require 'json'

class HTTP_Client

  def get(endpoint_uri, credentials)
    new_request = Net::HTTP::Get.new(endpoint_uri)
    new_request.basic_auth(credentials[0], credentials[1]) if !credentials.empty?
    response = make_request(endpoint_uri, new_request)
    parse_response(response)
  end

  def post(url, data)
    endpoint_uri = URI(url)
    new_request = Net::HTTP::Post.new(endpoint_uri)
    new_request.set_form_data(data)
    response = make_request(endpoint_uri, new_request)
    parse_response(response)
  end

  def make_request(endpoint, formatted_request)
    check_ssl = endpoint.scheme == "https"
    Net::HTTP.start(endpoint.host, endpoint.port, :use_ssl => check_ssl) do |client|
      retries = 5
      begin
        client.request(formatted_request)
      rescue Exception => ex
        retries -= 1
        retries > 0 ? retry : error_response(422, ex)
      end
    end
  end

  def parse_response(response)
    if (response.code =~ /^2/ )
      JSON.parse(response.body, symbolize_names: true)
    else
      puts response.body
      { error: response }
    end
  end

  private

  def error_response(err_code, exception)
    error = Struct.new(:code, :exception)
    error.new(err_code, exception)
  end
end

