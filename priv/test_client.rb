require 'rubygems'
require 'msgpack/rpc'

host = ARGV[0]
port = 9199 #ARGV[1]

print host, port
c = MessagePack::RPC::Client.new(host,port)
c.call(:hello)
c.call(:add, 2, 3)

