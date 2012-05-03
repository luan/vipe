require 'vim'

describe Vim do
  let(:vim) do
    Vim.new(shell: shell, executable: executable, server_name: server_name)
  end

  let(:shell) { mock 'shell' }
  let(:standard_cmd) do
    "#{executable} --servername #{server_name} --remote-send"
  end

  shared_examples_for "a Vim command proxy" do
    it "can send a cexpr Vim command to the shell" do
      shell.should_receive(:run).with(
        %Q(#{standard_cmd} "<esc>:cexpr ''<cr>")
      )
      vim.cexpr ''
    end

    it "can send cexpr with arguments" do
      shell.should_receive(:run).with(
        %Q(#{standard_cmd} "<esc>:cexpr 'echo \"hi\"'<cr>")
      )
      vim.cexpr 'echo "hi"'
    end

    it "can send a caddexpr Vim command to the shell" do
      shell.should_receive(:run).with(
        %Q(#{standard_cmd} "<esc>:caddexpr 'some:1:stuff'<cr>")
      )
      vim.caddexpr 'some:1:stuff'

      shell.should_receive(:ru).with(
        %Q(#{standard_cmd} "<esc>:caddexpr 'other:2:things'<cr>")
      )
      vim.caddexpr 'other:2:things'
    end
  end

  context "for mvim" do
    let(:executable) { 'mvim' }
    let(:server_name) { 'MVIMSERVER' }

    it_behaves_like "a Vim command proxy"
  end

  context "for vim" do
    let(:executable) { 'vim' }
    let(:server_name) { 'VIMSERVER' }

    it_behaves_like "a Vim command proxy"
  end
end
