require 'faraday'

module Sendbird
  module Client
    class ApiKeyMissingError < StandardError; end
    PUBLIC_METHODS = [:get, :post, :put, :delete]

    PUBLIC_METHODS.each do |method|
      define_method(method) do |path: , params: nil , body: nil|
        fail ApiKeyMissingError.new(api_key_message) if Sendbird.api_key.nil?
        response = request(method: method, path: path, params: params, body: body)
        Response.new(response.status, response.body)
      end
    end

    def build_url(*args)
      if args.any?
        new_args = args.dup
        new_args.insert(0, self.const_get('ENDPOINT')).join('/')
      else
        self.const_get('ENDPOINT')
      end
    end

    private
    def conn
      @conn ||= Faraday.new(url: Sendbird::Configuration::SENDBIRD_ENDPOINT) do |c|
                  c.request  :url_encoded
                  c.adapter  Faraday.default_adapter
                end
    end

    def request(method:, path:, params:, body:)
      conn.send(method) do |req|
        req.url path, params
        req.headers['Api-Token'] = Sendbird.api_key
        req.headers['Content-Type'] = 'application/json, charset=utf8'
        req.body = body.to_json if body
      end
    end

    def api_key_message
      'Please set up your api key'
    end
  end
end
