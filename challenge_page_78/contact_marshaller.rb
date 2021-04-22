require_relative 'contact_name_marshaller.rb'
require_relative 'phone_number_marshaller.rb'

class ContactMarshaller
  def initialize(contact)
    self.contact_name_marshaller = ContactNameMarshaller.new(contact.name)
    self.phone_number_marshaller = PhoneNumberMarshaller.new(contact.phone_number)
  end

  private

  def dump
    [
      contact_name_marshaller.dump,
      phone_number_marshaller.dump
    ]
  end

  attr_accessor :contact_name_marshaller, :phone_number_marshaller
end