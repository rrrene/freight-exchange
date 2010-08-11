Hirb.enable

fields = {
  "User" => %w(id company_id login email),
}

output = {}
fields.each do |model, fields|
  output[model.to_s] = {
    :options => {:fields => fields}
  }
end

Hirb::View.enable :output => output