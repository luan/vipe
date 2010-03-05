#!/usr/bin/env ruby

pipe_path = File.join(ENV['HOME'], 'test_server_pipe')
`mkfifo #{pipe_path}` unless File.exists?(pipe_path)

while true do
  File.open pipe_path, 'w+' do |file|
    command = file.gets
    system "clear"
    puts command
    system command
  end
end

