require_relative 'contact_marshaller.rb'

class ContactRepository
  def initialize
    self.file = "./database"
  end

  def persist(contact)
    File.open(file, 'ab') do |f|
      ContactMarshaller.new.dump(contact, f)
    end
  end

  def list_all
    contacts = []

    File.open(file, 'rb') do |f|
      while f.pos < f.size
        puts "filePos: #{f.pos}, fileSize: #{f.size}"
        contacts << ContactMarshaller.new.load(f)
      end
    end

    contacts
  end

  private

  attr_accessor :file
end