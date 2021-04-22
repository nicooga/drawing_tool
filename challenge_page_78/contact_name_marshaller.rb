class ContactNameMarshaller
  CHARACTERS = [' ', *('a'..'z')]

  CHAR_MAP = CHARACTERS.to_a.reduce({}) do |acc, letter, index|
    acc.merge(letter => index)
  end

  if (CHARACTERS.size > (2 ** 5) - 1)
    raise 'Valid characters size can not exceede `2^5 - 1`, as we are storing them using only the first 5 bytes in an 8 bit integer'
  end

  def initialize(name)
    self.name = name
  end

  def dump
  end

  private

  attr_accessor :name, :file
end