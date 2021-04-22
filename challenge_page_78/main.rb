# Objective: design an adress book database (name, phone number, etc) using a binary representation
require_relative 'contact.rb'
require_relative 'contact_marshaller.rb'
require_relative 'coctact_repository.rb'

contact_repository = ContactRepository.new
contact = Contact.new('Ricardo Arjona', '1524088205');
contact_repository.persist(contact)