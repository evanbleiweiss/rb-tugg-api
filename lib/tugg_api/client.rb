require 'rubygems'
require 'em-http-request'

module TuggApi
  class Client
    TUGG_API = 
    def initialize(api_key, api_version = 1)
      @api_key = api_key
      @api_version = api_version
    end

    def use_localhost?
      ENV['USE_LOCAL'].present?
    end

    # expects:
      # api_type: 'titles' or 'events'
      # id of event or title
      # format, defaults to json
      # debug = true, prints to stdout
    def get(options={})
      api_type = options[:api_type]
      id = options[:id]
      format = options[:format] || 'json'
      debug = options[:debug] || false

      response = nil # return value

      EventMachine.run do
        conn_options = {
          connect_timeout: 5,        # default connection setup timeout
          inactivity_timeout: 10    # default connection inactivity (post-setup) timeout
        }
        req_options = {
          redirects: 1,             # in case we're redirected by changes to Tugg API
          path: "api/#{api_type}/#{id}.#{format}",
          head: {'TUGG-API-KEY' => @api_key, 'TUGG-API-VERSION' => @api_version}
        }

        if use_localhost?
          http = EventMachine::HttpRequest.new('http://localhost:3000/', conn_options).get req_options
        else  
          http = EventMachine::HttpRequest.new('https://www.tugg.com/', conn_options).get req_options
        end

        http.errback do
          response = http.response
          p response if debug
          EM.stop
        end
        http.callback do
          response = http.response
          if debug
            p http.response_header.status
            p http.response_header
            p response
          end
          EM.stop
        end
      end

      return response
    end

  end
end
