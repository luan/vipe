require 'tempfile'
require 'vimrunner'

describe "test_client.vim" do
  let(:vim) do
    Vimrunner::Runner.start_vim.tap do |vim|
      vim.command "source plugin/test_client.vim"
    end
  end

  def pipe
    @file.rewind
    @file.read
  end

  before do
    new_file
    vim.normal ":let g:test_server_pipe = '#{@file.path}'<CR>"
  end

  after do
    FileUtils.rm_f ".*_spec.rb.swp"
    vim.normal ":qa!<CR>"
  end

  def new_file
    @file = Tempfile.new("test_client_spec_pipe_#{rand(9999999)}")
  end

  def clear_pipe
    new_file
    vim.normal ":let g:test_server_pipe = '#{@file.path}'<CR>"
  end

  def run_test
    vim.command 'RunTest'
  end

  def run_line
    vim.command 'RunTestLine'
  end

  def run_again
    vim.command "RunTestAgain"
  end

  def run_previous
    vim.command 'RunTestPrevious'
  end

  def edit(path)
    vim.edit path
  end

  shared_examples_for "the whole spec is run" do
    context "(shared)" do
      let(:spec_filename) { 'example_spec.rb' }
      before { edit filename }

      it "sends the spec file path to the pipe" do
        run_test
        pipe.should =~ /rspec/
        pipe.should =~ /#{spec_filename}$/
      end

      it "shows an appropriate message" do
        run_test.should =~ /#{spec_filename}/
      end
    end
  end

  shared_examples_for "the whole feature is run" do
    context "(shared)" do
      let(:feature_filename) { 'example.feature' }
      before { edit filename }

      it "sends the feature file path to the pipe" do
        run_test
        pipe.should =~ /cucumber/
        pipe.should =~ /#{feature_filename}$/
      end

      it "shows an appropriate message" do
        run_test.should =~ /#{feature_filename}/
      end
    end
  end

  describe "running when there is no file open" do
    it "does not send anything to the pipe" do
      run_test
      pipe.should == ''
    end
  end

  describe "running a whole spec from the spec file" do
    let(:filename) { 'example_spec.rb' }
    it_behaves_like "the whole spec is run"
  end

  describe "running a whole feature from the feature file" do
    let(:filename) { 'example.feature' }
    it_behaves_like "the whole feature is run"
  end

  describe "running a whole spec from the source file" do
    let(:filename) { 'example.rb' }
    it_behaves_like "the whole spec is run"
  end

  describe "running a line spec focused to a line from the spec file" do
    let(:filename) { "example_spec.rb" }
    let(:spec_filename) { 'example_spec.rb' }

    let(:line) { 10 }

    before do
      edit filename
      vim.insert((['some text'] * (line + 1)).join("\n"))
      vim.normal "#{line}gg"
    end

    it "sends the spec file path to the pipe, with the line number" do
      run_line
      pipe.should =~ /rspec/
      pipe.should =~ /#{spec_filename}:#{line}$/
    end

    it "shows an appropriate message" do
      run_line.should =~ /#{spec_filename}:#{line}/
    end

    it "can be re-run" do
      run_line
      clear_pipe
      pipe.should == ''
      run_again
      pipe.should =~ /#{spec_filename}:#{line}$/
    end
  end

  context "when there is no previous test" do
    it "warns the user when trying to re-run" do
      edit "file1_spec.rb"
      run_again.should =~ /No previous test run/
      pipe.should == ''
    end
  end

  describe "re-running previous unfocused test" do
    before do
      edit "file1_spec.rb"
      run_test
      edit "file2_spec.rb"
      run_test
    end

    it "runs the same test again" do
      run_again
      pipe.should =~ /rspec/
      pipe.should =~ /file2_spec\.rb$/
    end
  end

  describe "running previous test" do
    context "when previous test was run" do
      it "runs appropriate test" do
        edit "file1_spec.rb"
        run_test
        edit "file2_spec.rb"
        run_test
        run_previous
        pipe.should =~ /rspec/
        pipe.should =~ /file1_spec\.rb$/
      end
    end

    context "when no previous test was run" do
      it "displays an error" do
        run_previous.should =~ /No previous/
      end
    end
  end
end
