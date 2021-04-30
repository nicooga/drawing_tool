class UUIDGenerator
  def initialize
    @mutex = Mutex.new
    @last_id_used = 0
  end

  def generate
    @mutex.synchronize do
      @last_id_used += 1
    end
  end
end