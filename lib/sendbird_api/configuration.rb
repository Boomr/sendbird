module SendbirdApi
  module Configuration
    PUBLIC_METHODS = [:api_key]

    SENDBIRD_ENDPOINT = 'https://api.sendbird.com/v3/'

    attr_accessor *PUBLIC_METHODS

    def config
      yield self
    end
  end
end
