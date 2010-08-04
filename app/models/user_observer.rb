class UserObserver < Recorder::Observer
  ignore :updated_at, :created_at, :last_request_at, :perishable_token
end
