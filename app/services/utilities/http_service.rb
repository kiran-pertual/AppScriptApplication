module Utilities
  class HttpService
    attr_reader :authenticate
    include HTTParty
    base_uri ""

    def initialize
      @authenticate = GoogleAuthentication.new
      @options = {}
    end

    def post_to_endpoint(path, body, headers = content_type)
      merge_headers(headers)
      result = self.class.post(URI.parse(path), :body => body.to_json, :headers => @options)
      result
    end

    private

    def authorization
      access_token = authenticate.access_token
      { "Authorization" => "Bearer #{access_token}" } if access_token.present?
    end

    def content_type
      { "Content-Type" => "application/x-www-form-urlencoded" }
    end

    def merge_headers(headers)
      check_and_merge(authorization)
      check_and_merge(headers)
      puts @options.inspect
    end

    def check_and_merge(attribute)
      @options.merge!(attribute) if attribute.present?
    end
  end
end