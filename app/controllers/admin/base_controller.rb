# The BaseController is the controller every other backend controller inherits
# from. He is mainly responsible for providing basic functionality to the 
# backend, e.g. rights management.
class Admin::BaseController < InheritedResources::Base
  role_required :administrator
end