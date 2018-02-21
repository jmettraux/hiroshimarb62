
require 'ffi'


module WebEvent
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
end

HttpCallback = Proc.new do |request, args|
  buf = WebEvent.evbuffer_new
  WebEvent.evbuffer_add(buf, "hello world !\n", 4)
  WebEvent.evhttp_send_reply(request, 200, 'OK', buf)
  WebEvent.evbuffer_free(buf)
end

WebEvent.event_init
httpd = WebEvent.evhttp_start('0.0.0.0', 8000)
WebEvent.evhttp_set_gencb(httpd, HttpCallback, 0)
puts "listening on port 8000..."
WebEvent.event_dispatch

