# @abstract
class Command
  def self.letter
    raise NotImplementedError
  end

  def self.arguments
    raise NotImplementedError
  end

  def self.description
    raise NotImplementedError
  end

  def initialize(drawing, argument)
    self.drawing = drawing
    self.argument = argument
  end

  def execute
    raise NotImplementedError
  end

  private

  attr_accessor :drawing, :argument
end