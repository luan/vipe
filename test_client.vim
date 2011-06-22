ruby << EOF

#cucumber = 'jruby -S bundle exec /Users/andrew/dev/jruby-1.5.6/bin/cucumber'
cucumber = 'CUCUMBER_FORMAT=pretty bundle exec cucumber -r features'
#rspec = 'jruby -S bundle exec /Users/andrew/dev/jruby-1.5.6/bin/spec'
rspec = 'bundle exec rspec'
#rspec = 'vendor/plugins/rspec/bin/spec'
vows = 'vows --spec'

def send_to_test_server(command)
  File.open(File.join(ENV['HOME'], 'test_server_pipe'), 'w+') do |pipe|
    pipe.puts command
    pipe.flush
  end
  print "Sent #{command}"
end
EOF

function! RunScenario(scenario)
ruby << EOF
  buffer = VIM::Buffer.current
  filename = buffer.name
  command = "#{cucumber} #{buffer.name} --name '#{VIM::evaluate('a:scenario')}'"
  send_to_test_server(command)
EOF
endfunction

function! RunTest()
ruby << EOF
  buffer = VIM::Buffer.current
  filename = buffer.name
  extname = File.extname(buffer.name)
  dir = File.dirname(filename)
  basename = File.basename(filename)
  command = if extname.strip == '.feature'
              then "#{cucumber} #{filename}"
            elsif filename =~ /_spec\.rb/
              then "#{rspec} #{filename}"
            elsif extname.strip == '.js'
              then "cd #{dir} && #{vows} #{basename}"
            elsif filename =~ /html\.erb$/
              then "#{rspec} #{filename.sub('app/views', 'spec/views')}_spec.rb"
            else
              spec_filename = filename.
                gsub('app/helpers', 'spec/helpers').
                gsub('lib', 'spec/lib').
                gsub('app/models', 'spec/models').
                gsub('app/controllers', 'spec/controllers').
                gsub('app/mailers', 'spec/mailers').
                gsub('.rb', '_spec.rb')
              "#{rspec} #{spec_filename}"
            end
  send_to_test_server(command)
EOF
endfunction

function! RunExample()
ruby << EOF
  buffer = VIM::Buffer.current
  send_to_test_server("#{rspec} -l #{buffer.line_number} #{buffer.name}")
EOF
endfunction

