# VlSync
Synchronized VLC playback on multiple devices

## Getting Started
Getting started is very simple. First, install the Gem:
```
  gem install vlsync
```
or, in your gem file
```
  gem 'vlsync'
```

## Using the Gem
Launch the Gem through the command line  
```shell
  vlsync [options]
```

### Client
The Clients are computers you want to play media on.  
Starting the client is simple, using
```shell
  vlsync
```
or
```shell
  vlsync -c
```

The default running port is 5957, although it can be changed with the ``` -p [port] ``` option. The port MUST match your server's port, and should be free on both TCP and UDP streams. UDP [port+1] should also be open for client discovery to work.  

Devices with multiple network interfaces can specify ``` -h [hostname] ``` if the default interface doesn't work.

### Server
The Server is the computer responsible for control of the group of clients. The server is launched like so
```shell
  vlsync -s
```

The Server will automatically discover clients with the same ports on the same network. This is done with the ruby ``` <broadcast> ``` interface.  

The default running port is 5957, although it can be changed with the ``` -p [port] ``` option. The port MUST match the port of each of your clients, and should be free on both TCP and UDP streams. UDP [port+1] should also be open for discovery to work.  

Devices with multiple network interfaces can specify ``` -h [hostname] ``` if the default interface doesn't work.  

### Controlling the Server  
The server is controlled through ``` STDIN ```. The following are a few of the commands, with a full list of commands available through [VLC's RC documentation](help_list.txt)  

#### Play, Pause, Stop
Play will change the current media. Any paths can be provided, including local system, server, YouTube URL or any other VLC supported formats.
```shell
  play [path]
```
Pause will toggle the pausing of the current media. Keep in mind if you call ``` pause ```, you must call ``` pause ``` again to resume.  

Stop will cancel current playback until ``` play ``` is called again.  

#### Sync
Sync will pause the video on all machines and seek to 0. This syncs all machines to 0 seconds to ensure playback is Synchronized.
```shell
  sync
```

#### Rescan
Rescan will rescan the network for clients. Call this whenever a client is launched
```shell
  rescan
```

#### Quit
Exit VLC on every client. This doesn't shut down the client VlSync.
```shell
  quit
```
