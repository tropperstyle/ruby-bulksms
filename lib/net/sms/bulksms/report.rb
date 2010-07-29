require 'net/http'
require 'uri'

module Net
  module SMS
    module BulkSMS

      # Wraps up the functionality for report from the system
      class Report

        # The port the account service runs on
        SERVICE_PORT = 5567

        # Path to the account service gateway
        SERVICE_PATH = '/eapi/status_reports/get_report/2/2.0'
        
        def initialize(username, password, batch_id, country = 'uk', options = {})
          @username, @password = username, password
          @batch_id = batch_id
          @country = country
          @options = options
        end

        # Returns the number of credits left on a users account as a
        # float to 2 decimal places. Will raise an AccountError
        # if the credentials are wrong
        def retrieve
          Net::HTTP.start(Net::SMS::BulkSMS::host(@country), MESSAGE_SERVICE_PORT) do |http|
            http_string = self.to_http_query
            http_string << URI.encode("&" + @options.collect{|k,v| "#{k}=#{v}"}.join('&')) unless @options.empty?
            resp = http.get(MESSAGE_SERVICE_PATH + "?" + http_string)
            Response.parse(resp.body)
          end
        end

        # Returns the account credentials in the form of a http
        # query string for use by other gateway services
        def to_http_query
          URI.encode("username=#{@username}&password=#{@password}&batch_id=#{@batch_id}")
        end
      end
    end
  end
end
