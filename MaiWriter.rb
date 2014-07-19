class MaiWriter
  def initialize(filename, mode)
    @file = File.open(filename, mode)
    @mutex = Mutex.new
  end
  def write(str)
    @mutex.synchronize{
      @file.puts str
      @file.flush
    }
  end
end
