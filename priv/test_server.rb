require 'rubygems'
require 'msgpack/rpc'

class MyServer
  def initialize(svr)
    @svr = svr
  end
  
  def hello
    "ok"
  end
  
  def add(a, b)
    a + b
  end
  
  def exception
    raise "raised"
  end
  
  def async
    as = MessagePack::RPC::AsyncResult.new
    @svr.start_timer(1, false) do
      as.result "async"
    end
    as
  end
  
  def async_exception
    as = MessagePack::RPC::AsyncResult.new
    @svr.start_timer(1, false) do
      as.error "async"
    end
    as
  end
  
end

# def start_server port
port = 9199
  
svr = MessagePack::RPC::Server.new
svr.listen("0.0.0.0", port, MyServer.new(svr))
#Thread.start do
svr.run
#   svr.close
# end

  # cli = MessagePack::RPC::Client.new("127.0.0.1", port)
  # cli.timeout = 10
  
#   return svr
# end
