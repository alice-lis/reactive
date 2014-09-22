class DumbFactory

  MESSAGES_DIR = File.join(NSBundle.mainBundle.resourcePath, 'messages')

  def self.contacts n = 2
    names = ['Михаил Биленко', 'Сергей Качан', 'Андрей Шрамко', 'Алиса Кондратьева', 'Слава Додатко']
    contacts = []
    names.each do |name|
      contact = Contact.new :name => name

      messages = []

      5.times do |i|
        message = Message.new(
          :sender   => names[Random.rand(names.count)],
          :sent     => DumbFactory.random_date(3),
          :subject  => "In favour of #{names[Random.rand(names.count)]}",
          :body     => read_body(i) || default_body(i),
          :read_flag => false
        )
        message.addObserver(contact,
          forKeyPath:'read_flag',
          options:NSKeyValueObservingOptionNew,
          context:'read_flag')
        messages << message
      end
      contact.messages = messages
      contacts << contact
    end

    contacts
  end

  def self.read_body(num)
    file_path = File.join(MESSAGES_DIR, num.to_s)
    if File.exists?(file_path)
      file = File.open(file_path, 'r')
      String.new.tap do |res|
        file.each_line do |line|
          res << line
        end
        file.close
      end
    end
  end

  def self.default_body(num)
    "Hello! " + "This is a text for message #{num.to_s}. " * 5
  end

  def self.random_date(days)
    Time.new - rand(days * 24 * 60 * 60)
  end

end
