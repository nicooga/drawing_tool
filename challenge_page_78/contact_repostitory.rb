class ContactRepository
  def initialize
    self.file = File.open("./database", "a+b")
  end

  def persist(contact)
    ContactMarshaller.new(contact).dump
  end

  def list_all
  end
end