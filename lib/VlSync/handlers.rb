module VlSync
  class Handlers
    @handlers = {}

    def self.register handle, &block
      @handlers[handle] = block
    end
    def self.handlers; @handlers; end

    def self.get str
      @handlers.select { |key, val| (key =~ str) != nil }.first[1]
    end

    def self.has str
      @handlers.select { |key, val| (key =~ str) != nil }.size > 0
    end

    register /^re((scan)|(fresh))$/ do |server, handle, *args|
      server.refresh
    end

    register /^play$/ do |server, handle, *args|
      server.write "add #{args[0]}" if args.length > 0
    end

    register /^sync$/ do |server, handle, *args|
      server.write "seek 0"
      server.write "pause"
    end

    register /^clients$/ do |server, handle, *args|
      puts "Server Connections: #{server.sockets.inspect}"
    end

  end
end
