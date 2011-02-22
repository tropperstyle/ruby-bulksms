require 'net/http'
require 'uri'

module Net
  module SMS
    module BulkSMS

      # Wraps up the functionality for a user account on the system
      class Account

        # The port the account service runs on
        SERVICE_PORT = 7512

        # Path to the account service gateway
        SERVICE_PATH = '/eapi/1.0/get_credits.mc'

        attr_accessor :username, :password, :gateway

        def initialize(username, password, gateway)
          self.username = username
          self.password = password
          self.gateway = gateway
        end

        # Returns the number of credits left on a users account as a
        # float to 2 decimal places. Will raise an AccountError
        # if the credentials are wrong
        def credits
          Net::HTTP.start(gateway, SERVICE_PORT) do |http|
            response = http.post SERVICE_PATH, self.to_http_query
            if response.body.include?('|')
              rsp = Response.parse(response.body)
              raise AccountError, rsp.description, caller
            end
            response.body.to_f
          end
        end

        # Returns the account credentials in the form of a http
        # query string for use by other gateway services
        def to_http_query
          URI.encode("username=#{username}&password=#{password}")
        end
      end

      class AccountError < Exception; 	end
    end
  end
end
