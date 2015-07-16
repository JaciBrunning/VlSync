module VlSync
  class Server

    def initialize
      puts "Server Started on port #{VlSync.opts[:port]}"
      @discovery = Thread.new {
        s = UDPSocket.new
        s.bind(VlSync.opts[:bind], VlSync.opts[:port])
        loop do
          message, addr = s.recvfrom(255)
          if message =~ /PONG_VLSYNC/
            puts "Client Found: #{addr[2]}"
            @clients << addr

            tcp = TCPSocket.new addr[2], VlSync.opts[:port]
            @client_socks << tcp
          end
        end
      }
      @multisocket = UDPSocket.new
      @multisocket.setsockopt Socket::SOL_SOCKET, Socket::SO_BROADCAST, true

      refresh
      input
    end

    def sockets
      @client_socks
    end

    def input
      loop do
        line = gets.chop!
        match = line.match /(\w*)\s*(.*)/
        name = match[1].downcase
        args = match[2].split /\s+/

        if VlSync::Handlers.has name
          VlSync::Handlers.get(name).call(self, name, *args)
        else
          write line
        end
      end
    end

    def refresh
      puts "Refreshing list of Clients..."
      @client_socks.each {|sock| begin; sock.close; rescue; end} if defined? @client_socks
      @client_socks = []
      @clients = []
      @multisocket.send("DISCOVER_VLSYNC", 0, "<broadcast>", VlSync.opts[:port]+1)
    end

    def write message
      @client_socks.each {|sock| begin;
        sock.puts message
        sock.flush
      rescue; end}
    end

  end
end
