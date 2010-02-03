function! RunRspec()
ruby << EOF
  buffer = VIM::Buffer.current
  filename = buffer.name
  fork do
    File.open(File.join(ENV['HOME'], 'test_server_pipe'), 'w+') do |pipe|
      pipe.puts filename
      pipe.flush
    end
  end
  print "Sent #{File.basename(filename)}"
EOF
endfunction

