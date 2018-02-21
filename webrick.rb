
require 'webrick'


server =
  WEBrick::HTTPServer.new Port: 8000#, DocumentRoot: root

server.mount_proc '/' do |req, res|
  res.body = "Hello, world!\n"
end

server.start

