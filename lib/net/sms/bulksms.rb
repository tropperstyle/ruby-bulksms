# Author::		Luke Redpath (mailto:contact@lukeredpath.co.uk)
# License::		MIT

require File.dirname(__FILE__) + '/bulksms/account'
require File.dirname(__FILE__) + '/bulksms/message'
require File.dirname(__FILE__) + '/bulksms/response'
require File.dirname(__FILE__) + '/bulksms/report'

module Net
  module SMS

    # The main BulkSMS module contains some constants
    # for the different countries that are supported
    # and a helper method to return the correct URL
    # for the chosen country
    #
    # The countries/areas supported are:
    #  * UK
    #  * USA
    #  * Spain
    #  * South Africa
    #  * International/Europe

    module BulkSMS
      class Service
        # The port the message service rus on
        MESSAGE_SERVICE_PORT = 80 #5567

        # Path to the message service gateway
        MESSAGE_SERVICE_PATH = '/eapi/submission/send_sms/2/2.0'

        # returns an Account object for the credentials supplied to the service
        attr_accessor :account

        def initialize(username, password, gateway)
          self.account = Account.new(username, password, gateway)
        end
        
        # Sends the given Message object to the gateway for delivery
        def send_message(msg)
          payload = [account.to_http_query, msg.to_http_query].join('&')
          Net::HTTP.start(account.gateway, MESSAGE_SERVICE_PORT) do |http|
            resp = http.post(MESSAGE_SERVICE_PATH, payload)
            Response.parse(resp.body)
          end
        end

        #Openning single connection & sending an array of message objects
        def send_multiple(messages)
          responses=[]
          Net::HTTP.start(account.gateway, MESSAGE_SERVICE_PORT) do |http|
            messages.each do |msg|
              payload = [account.to_http_query, msg.to_http_query].join('&')
              resp = http.post(MESSAGE_SERVICE_PATH, payload)
              responses << Response.parse(resp.body)
            end
          end
          responses
        end

        # Creates a new Message object from the message text and recipient
        # given and sends to the gateway using send_message()
        def send(message, recipient)
          msg = Message.new(message, recipient)
          self.send_message(msg)
        end
      end
    end
  end
end
