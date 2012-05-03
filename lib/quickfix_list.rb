class QuickfixList
  def initialize(options)
    @vim = options[:vim]
  end

  def add(path, line, text)
    @vim.caddexpr [path, line, text].join(':')
  end

  def clear
    @vim.cexpr("")
  end
end
