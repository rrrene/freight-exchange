#!/usr/bin/env ruby -wKU

require File.join(File.dirname(__FILE__), 'lib', 'tasks', 'rdoc_html2latex')

class Doc < Thor
  desc "parse", "Parses the generated documentation for the application into *.tex files."
  def parse
    html_files = [readme_file] + Dir[File.join(html_path, '**', '*.html')]
    tex_includes = []
    
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
        warn "[excluded] #{tex_file}"
      end
    end
    
    all_include_commands = tex_includes.map { |t| "\\include{classes/#{t}}" }.join("\n")
    
    master_content = File.read(master_file)
    
    master_content.gsub!(/(\%\%\%begin_includes\%\%\%)(.+?)(\%\%\%end_includes\%\%\%)/m, "\\1\n#{all_include_commands}\n\\3")
    File.open(master_file, 'w') {|f| f.write(master_content) }
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