class PostingsController < RemoteController
  same_company_required :only => %w(edit update)
  ownership_required :only => %w(edit update)
end
