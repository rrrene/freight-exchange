#!/usr/bin/env ruby -wKU

require 'fileutils'
require File.join(File.dirname(__FILE__), 'lib', 'tasks', 'rdoc_html2latex')

thesis_file = File.join(File.dirname(__FILE__), '..', 'diplom.arbeit', 'tasks', 'thesis')
require thesis_file

glob = File.join(File.dirname(__FILE__), 'lib', 'tasks', '*.thor')
Dir[glob].each { |f| load(f) }

