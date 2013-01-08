require "net/http"
require "rack"

class PowProxy
  DEFAULT_HOST = "127.0.0.1"
  DEFAULT_PORT = 3000

  attr_reader :host, :port

  def initialize(options = {})
    @host = options.delete(:host) || ENV['POW_PROXY_HOST'] || DEFAULT_HOST
    @port = options.delete(:port) || ENV['POW_PROXY_PORT'] || DEFAULT_PORT
  end

  def call(env)
    begin
      request = Rack::Request.new(env)
      headers = {}
      env.each do |key, value|
        if key =~ /^http_(.*)/i
          headers[$1] = value
        end
      end

      headers["Content-Type"] = request.content_type if request.content_type
      headers["Content-Length"] = request.content_length if request.content_length

      http = Net::HTTP.new(@host, @port)
      http.start do |http|
        response = http.send_request(request.request_method, request.fullpath, request.body.read, headers)
        headers = response.to_hash
        headers.delete "transfer-encoding"
        [response.code, headers, [response.body]]
      end
    rescue Errno::ECONNREFUSED
      [500, {}, ["Could not establish a connection to #{@host}:#{@port}, make sure your that the process you are proxying to is running."]]
    end
  end
end
