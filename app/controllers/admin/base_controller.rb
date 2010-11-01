# The Admin::BaseController is the controller every other backend controller inherits
# from. He is mainly responsible for providing basic functionality to all controllers
# in the Admin module, e.g. rights management.
class Admin::BaseController < ApplicationController
  inherit_resources
  role_required :administrator
end