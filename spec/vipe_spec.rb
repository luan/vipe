require 'tempfile'
require 'vimrunner'

describe "vipe.vim" do
  let(:vim) do
    Vimrunner.start.tap do |vim|
      vim.command "source plugin/vipe.vim"
    end
  end

  before { clear_pipe }

  def clear_pipe
    @file = Tempfile.new("pipe_spec_pipe_#{rand(9999999)}")
    vim.normal ":let g:vipe_pipe = '#{@file.path}'<CR>"
  end

  def pipe
    @file.rewind
    @file.read
  end

  it "runs the appropriate command" do
    vim.command 'Vipe echo "something"'
    pipe.should =~ /echo "something"/
  end

  it "can be re-run" do
    vim.command 'Vipe aloha matata'
    pipe.should =~ /aloha matata/
    clear_pipe
    pipe.should == ''
    puts vim.command 'Vipe'
    pipe.should =~ /aloha matata/
  end

  it "has a command stack" do
    vim.command 'Vipe aloha matata'
    pipe.should =~ /aloha matata/

    clear_pipe

    vim.command 'Vipe hakuna matata'
    pipe.should =~ /hakuna matata/

    clear_pipe

    vim.command 'VipePop'
    pipe.should =~ /aloha matata/
  end

  context "when there is no previous test" do
    it "warns the user when trying to re-run" do
      vim.command('Vipe').should =~ /No previous command ran/
      pipe.should == ''
    end
  end
end
