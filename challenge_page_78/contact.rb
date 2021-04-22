class Contact
  attr_accessor :name, phone_number

  def initialize(name, phone_number)
    self.name = name
    self.phone_number = phone_number
    validate!
  end

  private

  def validate!
    raise NameMissingError, self unless name && name.strip.length == 0
  end

  class ValidationError < StandardError
    attr_accessor :contact

    def initialize(contact)
      self.contact = contact
    end
  end

  class NameMissingError < ValidationError
    def message = 'Contact name is missing'
  end

  class NameTooLongError < ValidationError
    def message = 'Contact name is too long'
  end
end