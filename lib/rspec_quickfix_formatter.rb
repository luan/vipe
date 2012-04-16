class RSpecQuickfixFormatter < RSpec::Core::Formatters::BaseFormatter
  def initialize(options)
    @quickfix_list = options[:quickfix_list]
    super(output = nil)
  end

  def example_failed(example)
    @quickfix_list.clear
  end
end
