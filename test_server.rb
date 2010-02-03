#!/usr/bin/env ruby

pipe_path = File.join(ENV['HOME'], 'test_server_pipe')
`mkfifo #{pipe_path}` unless File.exists?(pipe_path)

while true do
  File.open pipe_path, 'w+' do |file|
    test_path = file.gets
    extname = File.extname(test_path)

    command = if extname.strip == '.feature'
                then "cucumber #{test_path}"
              else "spec #{test_path}"
              end

    puts "\r\n#{command}"
    system command
  end
end

