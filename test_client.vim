ruby << EOF

#cucumber = 'jruby -S bundle exec /Users/andrew/dev/jruby-1.5.6/bin/cucumber'
cucumber = 'bundle exec cucumber -f pretty -r features'
#rspec = 'jruby -S bundle exec /Users/andrew/dev/jruby-1.5.6/bin/spec'
rspec = 'bundle exec rspec'
rspec_no_rails = "bundle exec rspec -I spec_no_rails"
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
      gsub(/app\/assets\/javascripts\/(.*)\.(?:coffee|js)$/, 'spec/javascripts/\1_spec.coffee').
      gsub(/lib\/(.*)\.(?:coffee|js)$/, 'spec/javascripts/\1_spec.coffee').
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
              "#{cucumber} #{filename}"
            elsif filename =~ /spec_no_rails/
              "#{rspec_no_rails} #{filename}"
            elsif filename =~ /_spec\.rb/
              "#{rspec} #{filename}"
            elsif %w(.coffee .js).include?(extname.strip)
              if File.exists?('spec/javascripts')
                "jasmine-headless-webkit #{spec_filename(filename)}"
              else
                "jasmine-headless-webkit -j spec/support/jasmine.yml #{spec_filename(filename)}"
              end
            elsif filename =~ /html\.erb$/
              "#{rspec} #{filename.sub('app/views', 'spec/views')}_spec.rb"
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

