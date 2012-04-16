require 'rspec_quickfix_formatter'

describe "rspec formatter" do
  describe "when the first failure occurs" do
    it "clears the quickfix list" do
      quickfix_list = mock

      formatter = RSpecQuickfixFormatter.new(
        quickfix_list: quickfix_list
      )
      example = RSpec::Core::Example.new(
        stub('example group').as_null_object,
        'some description',
        metadata = nil
      )
      quickfix_list.should_receive(:clear)
      formatter.example_failed(example)
    end

    it "adds the failed example to the quickfix list" do
      pending
    end
  end
end
