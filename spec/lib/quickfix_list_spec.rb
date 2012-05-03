require 'quickfix_list'

describe QuickfixList do
  let(:vim) { mock 'vim' }

  subject do
    described_class.new(vim: vim)
  end

  describe "clearing the list" do
    it "sends a cexpr with an empty argument to Vim" do
      aw
      vim.should_receive(:cexpr).with("")
      subject.clear
    end
  end

  describe "adding to the list" do
    it "sends a caddexpr to Vim" do
      path = '/full/path/to/some_filename_spec.rb'

      vim.should_receive(:caddexpr).
        with("#{path}:24:the way my test failed")

      subject.add(path, 24, 'the way my test failed')
    end
  end
end
