# Objective: design an adress book database (name, phone number, etc) using a binary representation
require_relative 'contact_marshaller.rb'

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


class ContactRepository
  def initialize
    self.file = File.open("./database", "a+b")
  end

  def persist(contact)
    ContactMarshaller.new(contact, file).dump
  end

  def find_by_name(name)
  end

  def find_by_phone_number(phone_number)
  end
end

contact_repository = ContactRepository.new
contact = Contact.new('Ricardo Arjona', '1524088205');
contact_repository.persist(contact)