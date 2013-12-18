require 'webrick'

server = WEBrick::HTTPServer.new(:Port => 8080)

server.mount_proc '/' do |req, res|
  res.body = req.path
  res.content_type = 'text/text'
end

trap('INT') { server.shutdown }

server.start