module VlSync
  class Client

    def initialize
      @args = ['--extraintf', 'rc', '--rc-host', "#{VlSync.opts[:hostname]}:#{VlSync.opts[:port]}"]
      puts "Client started at #{VlSync.opts[:hostname]} on port #{VlSync.opts[:port]}"
      @vlc = VlSync.vlc
      @pid = Process.spawn @vlc, *@args
      listener
    end

    def listener
      BasicSocket.do_not_reverse_lookup = true
      addr = [VlSync.opts[:bind], VlSync.opts[:port]+1]
      puts "Starting multicast at bind: #{addr[0]} on port #{addr[1]}"
      s = UDPSocket.new
      s.bind(addr[0], addr[1])
      loop do
        message, addr = s.recvfrom(255)
        if message =~ /DISCOVER_VLSYNC/
          sock = UDPSocket.new(addr[0])
          puts "Host Found: #{addr[2]}"
          sock.send("PONG_VLSYNC", 0, addr[2], VlSync.opts[:port])
        end
      end
    end

  end
end
