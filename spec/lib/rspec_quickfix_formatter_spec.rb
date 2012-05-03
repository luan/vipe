require 'rspec_quickfix_formatter'

describe RspecQuickfixFormatter do
  class StubExampleGroup < RSpec::Core::ExampleGroup; end

  let(:quickfix_list) { double 'quickfix list', add: nil, clear: nil }
  let(:formatter) do
    RspecQuickfixFormatter.new('', quickfix_list: quickfix_list)
  end

  it "uses defaults for all instances" do
    vim = double 'vim'
    shell = double 'shell'

    ENV.should_receive(:[]).with('VIM_SERVER').and_return('SOMESERVER')

    Shell.stub(:new).and_return(shell)

    Vim.should_receive(:new).with(
      server_name: 'SOMESERVER',
      shell: shell,
      executable: 'mvim'
    ).and_return(vim)

    QuickfixList.should_receive(:new).with(vim: vim)
    RspecQuickfixFormatter.new('')
  end

  before do
    StubExampleGroup.stub(:metadata).
      and_return(RSpec::Core::Metadata.new(metadata))
  end

  let(:description) { "makes coffee" }
  let(:exception) { "something bad happened\nand there were many lines" }
  let(:line_number) { 21 }
  let(:path) { '/full/path/to/toffee_apples_spec.rb' }

  let(:example) do
    RSpec::Core::Example.new(StubExampleGroup, description, metadata)
  end

  let(:metadata) do
    {
      file_path: path,
      description: description,
      line_number: line_number,
      execution_result: {
        exception: Exception.new(exception)
      }
    }
  end

  describe "when the first failure occurs" do
    it "clears the quickfix list" do
      quickfix_list.should_receive(:clear)
      formatter.example_failed(example)
    end

    it "adds the failed example to the quickfix list" do
      quickfix_list.should_receive(:add).
        with(path, line_number, "something bad happened and there were many lines")
      formatter.example_failed(example)
    end
  end

  describe "when the second failure occurs" do
    it "does not clear the quickfix list" do
      formatter.example_failed(example)

      quickfix_list.should_not_receive(:clear)
      formatter.example_failed(example)
    end

    it "adds the second failed example to the quickfix list" do
      formatter.example_failed(example)

      quickfix_list.should_receive(:add).
        with(path, line_number, "something bad happened and there were many lines")
      formatter.example_failed(example)
    end
  end
end
