class ContactNameMarshaller
  CHARACTERS = [' ', *('a'..'z')]

  CHAR_MAP = CHARACTERS.to_a.reduce({}) do |acc, letter, index|
    acc.merge(letter => index)
  end

  def initialize(name, file)
    self.name = name
    self.file = file
  end

  def dump(file)
    5.down_to(1) do |n|
      file.puts
    end
  end

  private

  attr_accessor :name, :file
end