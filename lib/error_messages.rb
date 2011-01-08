# ErrorMessages objects are used to render an array of error messages as XML and JSON.
class ErrorMessages
  #:call-seq:
  #   ErrorMessages.new(messages)
  #
  # Takes an array of strings and creates an ErrorMessages object.
  #
  #   arr = ['Unauthorized access']
  #   ErrorMessages.new(arr)
  def initialize(_messages)
    @messages = _messages
  end
  
  # Renders the given messages as XML.
  def to_xml(*args)
    '<?xml version="1.0" encoding="UTF-8"?><errors>' <<
      @messages.map { |m| "<error>#{m}</error>" }.join('') <<
        '</errors>'
  end
  
  # Renders the given messages as JSON.
  def to_json(*args)
    {:errors => @messages}.to_json
  end
end