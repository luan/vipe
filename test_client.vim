ruby << EOF

#cucumber = 'jruby -S bundle exec /Users/andrew/dev/jruby-1.5.6/bin/cucumber'
cucumber = 'CUCUMBER_FORMAT=pretty bundle exec cucumber -r features'
#rspec = 'jruby -S bundle exec /Users/andrew/dev/jruby-1.5.6/bin/spec'
rspec = 'bundle exec rspec -fd'
rspec_no_rails = "#{ENV['HOME']}/.rvm/rubies/ree-1.8.7-2011.03/bin/ruby -S rspec -I spec_no_rails -fd"
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
  def spec_filename(filename, type = 'spec')
    filename.
      gsub('app/helpers', "#{type}/helpers").
      gsub('lib', "#{type}/lib").
      gsub('app/models', "#{type}/models").
      gsub('app/controllers', "#{type}/controllers").
      gsub('app/mailers', "#{type}/mailers").
      gsub('.rb', '_spec.rb')
  end

  buffer = VIM::Buffer.current
  filename = buffer.name
  extname = File.extname(buffer.name)
  dir = File.dirname(filename)
  basename = File.basename(filename)
  command = if extname.strip == '.feature'
              then "#{cucumber} #{filename}"
            elsif filename =~ /spec_no_rails/
              then "#{rspec_no_rails} #{filename}"
            elsif filename =~ /_spec\.rb/
              then "#{rspec} #{filename}"
            elsif extname.strip == '.js'
              then "cd #{dir} && #{vows} #{basename}"
            elsif filename =~ /html\.erb$/
              then "#{rspec} #{filename.sub('app/views', 'spec/views')}_spec.rb"
            else
              spec_filename = spec_filename(filename)
              spec_no_rails_filename = spec_filename(filename, 'spec_no_rails')

              if File.exists?(spec_no_rails_filename)
                "#{rspec_no_rails} #{spec_no_rails_filename}"
              else
                "#{rspec} #{spec_filename}"
              end
            end
  send_to_test_server("time #{command}")
EOF
endfunction

function! RunExample()
ruby << EOF
  buffer = VIM::Buffer.current
  if buffer.name =~ /spec_no_rails/
    send_to_test_server("#{rspec_no_rails} -l #{buffer.line_number} #{buffer.name}")
  else
    send_to_test_server("#{rspec} -l #{buffer.line_number} #{buffer.name}")
  end
EOF
endfunction

