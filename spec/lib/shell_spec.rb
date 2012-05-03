require 'shell'

describe Shell do
  it "can execute arbitrary commands and return the result" do
    shell = Shell.new
    shell.run("echo 'somevalue'").should == 'somevalue'
    shell.run("yes | head -n 1").should == 'y'
  end
end
