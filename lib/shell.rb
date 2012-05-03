class Shell
  def run(*command)
    IO.popen(command) { |io| io.read.strip }
  end
end
