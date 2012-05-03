class Vim
  def initialize(options)
    @executable = options[:executable]
    @server_name = options[:server_name]
    @shell = options[:shell]
  end

  def cexpr(args)
    args.gsub!('"', '\"')
    run %Q(cexpr "#{args.lines.first.strip}")
  end

  def caddexpr(args)
    args.gsub!('"', '\"')
    run %Q(caddexpr "#{args.lines.first.strip}")
  end

  private

  def run(args)
    to_send = "<c-\\><c-n>:#{args}<cr>"

    @shell.run(
      @executable, '--servername', @server_name, '--remote-send', to_send
    )
  end
end
