require 'tempfile'
require 'vimrunner'

describe "vipe.vim" do
  let(:vim) do
    FileUtils.mkdir_p "/tmp/vipe_spec/vim1"
    Vimrunner.start.tap do |vim|
      puts vim.command "source plugin/vipe.vim"
      puts vim.command "cd /tmp/vipe_spec/vim1"
    end
  end

  let(:other_vim) do
    FileUtils.mkdir_p "/tmp/vipe_spec/vim2"
    Vimrunner.start.tap do |vim|
      vim.command "source plugin/vipe.vim"
      puts vim.command "cd /tmp/vipe_spec/vim2"
    end
  end

  def pipe_path
    vim.command("echo VipePipePath()")
  end

  def clear_pipe
    @file.close rescue nil
    @file = File.open(pipe_path, 'w+')
  end

  def pipe
    @file.rewind
    @file.read
  end

  before { clear_pipe }

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

  it "is scoped to its working directory" do
    vim.command('echo VipePipePath()').should include "_tmp_vipe_spec_vim1"
    other_vim.command('echo VipePipePath()').should include "_tmp_vipe_spec_vim2"
  end

  context "when there is no previous test" do
    it "warns the user when trying to re-run" do
      vim.command('Vipe').should =~ /No previous command ran/
      pipe.should == ''
    end
  end
end
