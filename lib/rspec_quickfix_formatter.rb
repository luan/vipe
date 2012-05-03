require 'rspec/core/formatters/base_formatter'
require 'quickfix_list'
require 'vim'
require 'shell'

class RspecQuickfixFormatter < RSpec::Core::Formatters::BaseFormatter
  def initialize(output, options = {})
    @quickfix_list = options[:quickfix_list] || QuickfixList.new(
      vim: Vim.new(
        executable: 'mvim',
        server_name: ENV['VIM_SERVER'],
        shell: Shell.new
      )
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
      exception_for(example)
    )
  end

  private

  def exception_for(example)
    example.metadata[:execution_result][:exception].
      to_s.gsub("\n", ' ')
  end
end
