require_relative './contact'
require_relative './contact_repository'

contact = Contact.new('Ricardo Jimenez', '9999999999')
contact_repository = ContactRepository.new

contact_repository.persist(contact)
contact_repository.persist(contact)

puts contact_repository.list_all.inspect