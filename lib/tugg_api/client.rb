require 'rubygems'
require 'em-http-request'

module TuggApi
  class Client
    TUGG_API = 
    def initialize(api_key, api_version = 1)
      @api_key = api_key
      @api_version = api_version
      p 'using local' if use_localhost?
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
 
    #looking for options passed to rails server/console
    #requires server name to be specified, e.g. '$ rails s webrick tugg-local' bc of order specific argument passing in rails
    #assumes 'http://localhost:3000' unless specified via tugg-[domain||port] options
    def use_localhost?
      ARGV.include?('tugg-local')
    end
    
    #usage: '$ rails c development tugg-local tugg-port 3001'
    def port?
      get_port if ARGV.include?('tugg-port')
    end
    
    #usage: '$ rails c development tugg-local tugg-domain mybox.dev'
    def domain?
      get_domain if ARGV.include?('tugg-domain')
    end

    #domain builder utilities
    def build_url
      if use_localhost?
        http = protocol('http')
        domain = hostname(domain? || 'localhost')
        port = api_port(port? || 3000) 
      else
        http = protocol
        domain = hostname
        port = api_port
      end
      url = "#{http}://#{domain}:#{port}/"
    end
    
    def api_port(port = 443)
      port
    end

    def hostname(domain = 'www.tugg.com')
      domain
    end

    def protocol(protocol= 'https')
      protocol
    end

    private

    def get_port
      pos = ARGV.index('tugg-port').next
      ARGV[pos]
    end
    
    def get_domain
      pos = ARGV.index('tugg-domain').next
      ARGV[pos]
    end

  end
end
