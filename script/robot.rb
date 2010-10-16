#!/usr/bin/env ruby -wKU

require 'rubygems'
require 'active_resource'
require 'active_support/inflector'
require 'factory_girl'

module Robot
  SITE = "http://localhost:3000/"
end

%w(actions active_resource_ext array_ext bot users places freight).each do |rb|
  require File.join(File.dirname(__FILE__), 'robot', rb)
end
