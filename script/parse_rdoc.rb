#!/usr/bin/env ruby -wKU

require 'nokogiri'
require 'rdoc2latex'

doc_path = File.join(File.dirname(__FILE__), '..', 'doc')

html_path = File.join(doc_path, 'app', 'classes')
tex_path = File.join(doc_path, 'tex', 'classes')

# `mkdir -p #{tex_path}`

html_files = Dir[File.join(html_path, '**', '*.html')]

tex_includes = []

html_files.each do |html_file|
  rel_path = html_file.gsub(/^#{html_path}/, '')[1..-1]
  tex_file = rel_path.gsub(/(\.html)$/, '.tex').gsub('/', '-')
  tex = RDoc2LaTex.new(html_file)
#  unless tex.empty?
    tex_includes << tex_file.gsub('.tex', '')
    tex.write_file( File.join(tex_path, tex_file) )
#  end
end

all_include_commands = tex_includes.map { |t| "\\include{classes/#{t}}" }.join("\n")

puts all_include_commands

#f = File.join(File.dirname(__FILE__), '..', 'doc', 'app', 'classes', 'Matching', 'Compare', 'Base.html')

#puts RDoc2LaTex.new(f)

#doc = Nokogiri::HTML(open(f))

#body = doc.css('body').first.to_s
#desc = doc.css("div#description")

#desc.css("a").each do |a|
#  unless a['href'] =~ /^http/
#    a.name = 'span'
#    a.delete('href')
#  end
#end

#desc.css("a").each do |a|
#  unless a['href'] =~ /^http/
#    a.name = 'span'
#    a.delete('href')
#  end
#end

#puts desc.to_s

