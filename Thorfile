#!/usr/bin/env ruby -wKU

require 'fileutils'

require File.join(File.dirname(__FILE__), 'lib', 'tasks', 'rdoc_html2latex')

thesis_file = File.join(File.dirname(__FILE__), '..', 'diplom.expose', 'tasks', 'thesis')
require thesis_file

class Doc < Thor
  include Thor::Actions
  source_root '.'
  include Thesis

  desc "app", "Generates the RDOC HTML files for the app"
  def app
    # TODO: Vielleicht von Hand per rdoc, um andere Sachen mit reinzunehmen...
    `rake doc:app`
    success "doc generated"
  end
  
  desc "pdf", "Generates a pdf from the generated tex files"
  def pdf
    inside File.dirname(master_file) do
      output = `pdflatex #{File.basename(master_file)}`
      puts output.scan(/^(Output written on .+)$/)
    end
    #puts `cd #{}; pdflatex #{File.basename(master_file)}`
    success "pdf generated"
  end
  
  desc "parse", "Parses the generated documentation for the application into *.tex files."
  def parse
    html_files = [readme_file] + Dir[File.join(html_path, '**', '*.html')]
    if html_files.size < 2
      failure "no doc in doc/app"
      exit
    end
    tex_includes = []
    
    FileUtils.rm_rf(tex_path)
    FileUtils.mkdir_p(tex_path)
    
    # `mkdir -p #{tex_path}`
    #puts html_files.join("\n")
    
    html_files.each do |html_file|
      rel_path = if html_file =~ /README_FOR_APP/
        "README_FOR_APP.html"
      else
        html_file.gsub(/^#{html_path}/, '')[1..-1]
      end
      tex_file = rel_path.gsub(/(\.html)$/, '.tex').gsub('/', '-')
      tex = RDocHTML2LaTex.new(html_file)
      tex.write_file( File.join(tex_path, tex_file) )
      unless tex.empty?
        tex_includes << tex_file.gsub('.tex', '')
      else
        alert "excluded: #{tex_file}"
      end
    end
    
    all_include_commands = tex_includes.map { |t| "\\include{classes/#{t}}" }.join("\n")
    
    master_content = File.read(master_file)
    
    master_content.gsub!(/(\%\%\%begin_includes\%\%\%)(.+?)(\%\%\%end_includes\%\%\%)/m, "\\1\n#{all_include_commands}\n\\3")
    File.open(master_file, 'w') {|f| f.write(master_content) }
    success "doc parsed"
  end
  
  private
  
  def doc_path
    File.join(File.dirname(__FILE__), 'doc')
  end
  
  def html_path
    File.join(doc_path, 'app', 'classes')
  end
  
  def readme_file
    File.join(doc_path, 'app', 'files', 'doc', 'README_FOR_APP.html')
  end
  
  def tex_path
    File.join(doc_path, 'tex', 'classes')
  end
  
  def master_file
    File.join(doc_path, 'tex', 'doc.tex')
  end
  
end