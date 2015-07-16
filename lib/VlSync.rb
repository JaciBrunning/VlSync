require "optparse"
require "socket"
require_relative "VlSync/version"
require_relative "VlSync/server"
require_relative "VlSync/client"
require_relative "VlSync/handlers"

module VlSync

  trap("INT") {exit;}

  VLC_PATHS = { :win_64 => "C:/Program Files (x86)/VideoLAN/VLC/vlc.exe",
        :win_32 => "C:/Program Files/VideoLAN/VLC/vlc.exe",
        :mac => "/Applications/VLC.app/Contents/MacOS/VLC",
        :linux => "vlc" }

  @opts = { :mode => :client, :hostname => Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3], :port => 5957, :bind => "0.0.0.0" }
  OptionParser.new do |o|
    o.on("-v VLC", "--vlc", "Set the VLC executable location") { |v| @opts[:vlc] = v }
    o.on("-c", "--client", "Set this instance as a client (DEFAULT)") { @opts[:mode] = :client }
    o.on("-s", "--server", "Set this instance as a server") { @opts[:mode] = :server }
    o.on("-h HOSTNAME", "--host", "Set the hostname of the client") { |h| @opts[:hostname] = h }
    o.on("-p PORT", "--port", "Set the port of the client(s)") { |port| @opts[:port] = port.to_i }
    o.on("-b BIND", "--bind", "Set the bind address of the client multicast") { |addr| @opts[:bind] = addr }
  end.parse!

  def self.opts
    @opts
  end

  def self.os
    if (/Windows/ =~ ENV['OS']) != nil
      return :windows
    elsif (/darwin/ =~ RUBY_PLATFORM) != nil
      return :darwin
    else
      return :linux
    end
  end

  def self.vlc
    return @opts[:vlc] if @opts.include? :vlc
    op_s = os
    return (File.exist?(VLC_PATHS[:win_64]) ? VLC_PATHS[:win_64] : VLC_PATHS[:win_32]) if op_s == :windows
    return VLC_PATHS[:mac] if op_s == :darwin
    return VLC_PATHS[:linux] if op_s == :linux
  end

  def self.launch
    if @opts[:mode] == :server
      puts "Starting in Server mode..."
      @instance = VlSync::Server.new
    else
      puts "Starting in Client mode..."
      @instance = VlSync::Client.new
    end
  end

  launch

end
