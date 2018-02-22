
require 'ffi'


class WebServer

  module Ev
    extend FFI::Library

    ffi_lib '/usr/local/lib/libevent.dylib'

    attach_function :event_init, [], :pointer
    attach_function :event_dispatch, [], :int
    attach_function :evbuffer_new, [], :pointer
    attach_function :evbuffer_add, [ :pointer, :string, :int], :pointer
    attach_function :evbuffer_free, [ :pointer ], :void
    callback :http_callback, [ :pointer, :pointer ], :void
    attach_function :evhttp_start, [ :string, :int ], :pointer
    attach_function :evhttp_set_gencb, [ :pointer, :http_callback, :int ], :int
    attach_function :evhttp_send_reply, [ :pointer, :int, :string, :pointer ], :void
    attach_function :evhttp_request_get_uri, [ :pointer ], :string
  end

  def initialize

    @paths = []

    @callback =
      Proc.new do |request, args|
        begin

          t = Time.now

          buffer = Ev.evbuffer_new
          path = Ev.evhttp_request_get_uri(request)

          _, block = @paths.find { |pa, bl| pa == path }

          icode, scode, text = [ 404, 'Not Found', '.' ]
          icode, scode, text = [ 200, 'OK', block.call ] if block

          Ev.evbuffer_add(buffer, text, text.length)
          Ev.evhttp_send_reply(request, icode, scode, buffer)

          Ev.evbuffer_free(buffer)

          puts "GET #{path} #{icode} took #{(Time.now - t) * 1000.0}ms"

        rescue => err; p err; end
      end
  end

  def start

    Ev.event_init

    httpd = Ev.evhttp_start('0.0.0.0', 8000)
    Ev.evhttp_set_gencb(httpd, @callback, 0)

    puts "PID #{$$} listening on port 8000..."

    Ev.event_dispatch
  end

  def serve(path, &block)

    @paths << [ path, block ]
  end
end


server = WebServer.new

server.serve('/') do
  "Hello libevent world!\n"
end

server.start

