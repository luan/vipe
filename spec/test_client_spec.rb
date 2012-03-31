require 'tempfile'
require 'vimrunner'

# NB: don't type / move mouse while spec is running!
describe "test_client.vim" do
  let!(:vim) do
    Vimrunner::Runner.start_vim.tap do |vim|
      vim.normal ":let g:test_server_pipe = '#{file.path}'<CR>"
      vim.command "source plugin/test_client.vim"
    end
  end

  after do
    vim.normal ":q!<CR>"
    FileUtils.rm_f ".#{filename}.swp" if defined? filename
  end

  let(:file) { Tempfile.new('test_client_spec_pipe') }
  let(:spec_filename) { 'example_spec.rb' }

  def run_test
    vim.command 'call RunTest()'
  end

  def run_line
    vim.command 'call RunTestLine()'
  end

  def edit(path)
    vim.edit path
  end

  def pipe
    file.read
  end

  describe "running when there is no file open" do
    it "does not send anything to the pipe" do
      run_test
      pipe.should be_empty
    end
  end

  shared_examples_for "the whole spec is run" do
    context "(shared)" do
      before { edit filename }

      it "sends the spec file path to the pipe" do
        run_test
        pipe.should =~ /#{spec_filename}$/
      end

      it "shows an appropriate message" do
        run_test.should =~ /#{spec_filename}/
      end
    end
  end

  describe "running a whole spec from the spec file" do
    let(:filename) { 'example_spec.rb' }
    it_behaves_like "the whole spec is run"
  end

  describe "running a whole spec from the source file" do
    let(:filename) { 'example.rb' }
    it_behaves_like "the whole spec is run"
  end

  describe "running a line spec focused to a line from the spec file" do
    let(:filename) { 'example_spec.rb' }

    before do
      edit filename
      vim.insert((['some text'] * 10).join("\n"))
      vim.normal "5gg"
    end

    it "sends the spec file path to the pipe, with the line number" do
      run_line
      pipe.should =~ /#{spec_filename}:5$/
    end

    it "shows an appropriate message" do
      run_line.should =~ /#{spec_filename}:5/
    end
  end
end
