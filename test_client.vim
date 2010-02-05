ruby << EOF
def send_to_test_server(command)
  fork do
    File.open(File.join(ENV['HOME'], 'test_server_pipe'), 'w+') do |pipe|
      pipe.puts command
      pipe.flush
    end
  end
  print "Sent #{command}"
end
EOF

function! RunTest()
ruby << EOF
  buffer = VIM::Buffer.current
  filename = buffer.name
  extname = File.extname(buffer.name)
  command = if extname.strip == '.feature'
              then "cucumber #{buffer.name}"
            else "spec #{buffer.name}"
            end
  send_to_test_server(command)
EOF
endfunction

function! RunExample()
ruby << EOF
  buffer = VIM::Buffer.current
  send_to_test_server("spec -l #{buffer.line_number} #{buffer.name}")
EOF
endfunction

