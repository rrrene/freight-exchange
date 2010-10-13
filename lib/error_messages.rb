class ErrorMessages
  def initialize(_messages)
    @messages = _messages
  end
  
  def to_xml(*args)
    '<?xml version="1.0" encoding="UTF-8"?><errors>' <<
      @messages.map { |m| "<error>#{m}</error>" }.join('') <<
        '</errors>'
  end
  
  def to_json(*args)
    {:errors => @messages}.to_json
  end
end