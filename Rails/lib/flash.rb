#Incomplete – Still working on it

class Flash
  def initialize
    @messages = Hash.new { Array.new }
    @now = false
  end

  def []=(type, message)
    if @messages[type].empty?
      @messages[type] = [message]
    else
      @messages[type] << message
    end
  end

  def [](type)
    messages = @messages[type]
    @messages.delete(type)
    messages
  end

  def now
    @now = true
    self
  end
end
