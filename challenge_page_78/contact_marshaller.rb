require_relative 'contact.rb'

def byte_map(chars)
  char_to_byte_map =
    chars.each.with_index.reduce({}) do |acc, (c, index)|
      acc.merge(c => index + 1)
    end

  byte_to_char_map =
    chars.each.with_index.reduce({}) do |acc, (c, index)|
      acc.merge(index + 1 => c)
    end

  [char_to_byte_map, byte_to_char_map]
end

class ContactMarshaller
  FIELD_SEPARATOR = 0

  CHAR_TO_BYTE, BYTE_TO_CHAR = byte_map([' ', *('a'..'z')])
  NUMBER_TO_BYTE, BYTE_TO_NUMBER = byte_map('0'..'9') 

  def dump(contact, file)
    str =
      [contact.name.length].pack('C') +
      dump_string(contact.name) +
      dump_phone_number(contact.phone_number)

    file.write(str)
  end

  def load(file)
    contact_name_length = file.read(1).unpack('C').first

    contact_name =
      file.read(contact_name_length).unpack('C*').map do |byte|
        BYTE_TO_CHAR.fetch(byte)
      end.join

    phone_number =
      file.read(15).unpack('C*').map do |byte|
        next "0" if byte === 0
        BYTE_TO_NUMBER.fetch(byte)
      end.join

    Contact.new(contact_name, phone_number)
  end

  private

  def dump_phone_number(phone_number)
    bytes = dump_digit(phone_number)

    if bytes.length < 15
      missing_digits = 15 - bytes.length
      missing_digits.times { bytes.prepend("\x00") }
    end

    bytes
  end

  def dump_string(str)
    str.downcase.chars.map do |char|
      CHAR_TO_BYTE.fetch(char)
    end.pack('C*')
  end

  def dump_digit(str)
    str.chars.map do |char|
      NUMBER_TO_BYTE.fetch(char)
    end.pack('C*')
  end
end