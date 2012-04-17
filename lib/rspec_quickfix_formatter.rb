require 'quickfix_list'
require 'vim'

class RSpecQuickfixFormatter < RSpec::Core::Formatters::BaseFormatter
  def initialize(options = {})
    @quickfix_list = options[:quickfix_list] || QuickfixList.new(
      vim: Vim.new(server_name: ENV['VIM_SERVER'])
    )
    @fail_count = 0
    super(output = nil)
  end

  def example_failed(example)
    @fail_count += 1

    @quickfix_list.clear if @fail_count == 1
    @quickfix_list.add(
      example.file_path,
      example.metadata[:line_number],
      example.description
    )
  end
end
