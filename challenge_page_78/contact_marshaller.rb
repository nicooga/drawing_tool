require_relative 'contact_name_marshaller.rb'
require_relative 'phone_number_marshaller.rb'

class ContactMarshaller
  def initialize(contact)
    self.contact_name_marshaller = ContactNameMarshaller.new(contact.name, file)
    self.phone_number_marshaller = PhoneNumberMarshaller.new(contact.phone_number, file)
  end

  private

  def dump
    ContactNameMarshaller.dump(file)
  end

  attr_accessor :contact_name_marshaller, :file
end