require_relative './status'

module Nest
  class Client
    def initialize(email, password)
      @email = email
      @password = password
    end

    def fetch_status
      authenticate!(email, password) unless auth

      request = HTTParty.get(request_url, headers: request_headers)
      result = Oj.load(request.body)

      Status.new(result, auth[:user_id])
    end

    private

    attr_reader :email, :password, :auth

    LOGIN_URL = 'https://home.nest.com/user/login'
    USER_AGENT = 'Nest/1.1.0.10 CFNetwork/548.0.4'

    def authenticate!(email, password)
      request =
        HTTParty.post(
          LOGIN_URL,
          body:    { username: email, password: password },
          headers: { 'User-Agent' => USER_AGENT }
        )

      response = Oj.load(request.body)

      @auth = {
        token: response['access_token'],
        user_id: response['userid'],
        transport_url: response['urls']['transport_url']
      }
    end

    def request_url
      @request_url ||= "#{auth[:transport_url]}/v2/mobile/user.#{auth[:user_id]}"
    end

    def request_headers
      @request_headers ||= {
        # 'Host'                  => self.transport_host,
        'User-Agent'            => USER_AGENT,
        'Authorization'         => 'Basic ' + auth[:token],
        'X-nl-user-id'          => auth[:user_id],
        'X-nl-protocol-version' => '1',
        'Accept-Language'       => 'en-us',
        'Connection'            => 'keep-alive',
        'Accept'                => '*/*'
      }
    end
  end
end
