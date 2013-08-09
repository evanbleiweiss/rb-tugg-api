require 'rubygems'
require 'em-http-request'

module TuggApi
  class Client
    TUGG_API = 
    def initialize(api_key, **config)
      @api_key = api_key
      @api_version = config[:api_version] || 1
      @api_protocol = config[:api_protocol] || 'https'
      @api_host = config[:api_host] || 'www.tugg.com'
      @api_port = config[:api_port] || 443
      use_localhost?
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

        http = EventMachine::HttpRequest.new(build_url, conn_options).get req_options

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
    
    def build_url(*args)
      url = "#{@api_protocol}://#{@api_host}:#{@api_port}/"
    end
    
    #dont need to specify all connection options if using shorthand
    def use_localhost?
      if ENV['LOCAL'].present?
        @api_protocol = 'http'
        @api_host     = 'localhost'
        @api_port     = 3000
        p "Expecting Tugg API at: #{build_url}"
      end
    end
  end
end
