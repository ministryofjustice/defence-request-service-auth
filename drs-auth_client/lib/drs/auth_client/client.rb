require 'faraday'

module Drs
  module AuthClient
    class Client
      def initialize(auth_token)
        @auth_token = auth_token
      end

      def get(path)
        response = conn.get do |request|
          request.url path
          request.headers['Authorization'] = "Bearer #{@auth_token}"
        end

        if response.status == 200
          response.body
        else
          nil
        end
      end

      private

      def conn
        api_url = "#{AuthClient.host}/api/#{AuthClient.version}"

        Faraday.new(api_url)
      end
    end
  end
end