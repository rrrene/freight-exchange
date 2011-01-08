#!/usr/bin/env ruby -wKU

#
# Used by Thor.
#

require 'nokogiri'

class ::String # :nodoc:
  def escape_special_tex_chars(chars = %w($ % _ { } & #))
    str = ""
    env = nil
    self.each do |line|
      if line =~ /<pre>/
        env = :pre
      elsif line =~ /<\/pre>/
        env = nil
      end
      unless env == :pre
        line = line.gsub(/([\$\%\_\{\}\&\#])/) do |s|
          "\\" + $1
        end
      end
      str << line << "\n"
    end
    str
  end
  
  def replace_html_tag_with_tex_command(html, tex)
    gsub(/<#{html}[^>]*>(.+?)<\/#{html}>/m, "\\#{tex}{\\1}")
  end
  
  def replace_html_block_with_tex_environment(html, tex)
    replace_opening_html_tag_with(html, "\\begin{#{tex}}").
    replace_closing_html_tag_with(html, "\\end{#{tex}}")
  end
  
  def replace_opening_html_tag_with(html, str)
    gsub(/<#{html}[^>]*>/, str)
  end
  
  def replace_closing_html_tag_with(html, str)
    gsub(/<\/#{html}>/, str)
  end
  
  def remove_html_tags(*tags)
    tags.inject(self) do |str, tag|
      str = str.gsub(/<\/*#{tag}[^>]*>/, '')
    end
  end
  
end

class RDocHTML2LaTex # :nodoc:
  attr_accessor :uri
  attr_accessor :doc
  
  def initialize(_uri)
    self.uri = _uri
    html = open(uri).read.gsub('<br />', '<br>')
    self.doc = Nokogiri::HTML(html) 
    clean_up!
  end
  
  def clean_up!
    doc.css("head title").remove if readme?
    remove_source_code!
    remove_all_relative_links!
    modify_method_sections!
    modify_method_names!
  end
  
  def empty?
    to_s.strip == [title, title_label].join("\n").strip
  end
  
  def remove_source_code!
    doc.css("a.source-toggle").remove
    doc.css("div.method-source-code").remove
  end
  
  def remove_all_relative_links!
    doc.css("a").each do |a|
      unless a['href'] =~ /^http/
        a.name = 'span'
        a.delete('href')
      end
    end
  end
  
  def modify_method_sections!
    doc.css("h3.section-bar").each do |node|
      node.name = 'h2'
    end
  end
  
  def modify_method_names!
    doc.css("span.method-name").each do |node|
      content = node.content.to_s.gsub("\n", " <br> ")
      node.content = "<vspace>\n<methodname>#{content}</methodname>"
    end
    doc.css("span.method-args").each do |node|
      node.content = "<methodargs>#{node.content}</methodargs>" #.split(/\n/).map { |line| line.gsub('<br>', '').strip }.join('<br>')
    end
  end
  
  # TODO: Html entities escaping via gem
  # TODO: don't escape special chars in verbatim environment
  # 
  def texify(selector)
    #puts doc.css(selector).to_s
    doc.css(selector).to_s.
    gsub('<<', '\<\<').
    gsub('&amp;', '&').gsub('&gt;', '>').gsub('&lt;', '<').
    escape_special_tex_chars.
    replace_opening_html_tag_with(:br, "\\\\\\\\").
    replace_html_tag_with_tex_command(:title, :"section*").
    replace_html_tag_with_tex_command(:h1, :"section*").
    replace_html_tag_with_tex_command(:h2, :"subsection*").
    replace_html_tag_with_tex_command(:h3, :"subsubsection*").
    replace_html_tag_with_tex_command(:h4, :paragraph).
    replace_html_tag_with_tex_command(:a, :url).
    replace_html_tag_with_tex_command(:tt, :texttt).
    replace_opening_html_tag_with(:vspace, '\\vspace{0.5cm}').
    replace_html_tag_with_tex_command(:methodname, :textbf).
    replace_html_tag_with_tex_command(:methodargs, :textit).
    replace_opening_html_tag_with(:li, '\\item ').
    replace_closing_html_tag_with(:li, '').
    replace_html_block_with_tex_environment(:ul, :itemize).
    replace_html_block_with_tex_environment(:pre, :verbatim).
    remove_html_tags(:p, :span, :div).
    gsub(/\n\n/, "\n").
    to_s
  end
  
  def readme?
    uri =~ /README_FOR_APP/
  end
  
  def title
    @title ||= texify("head title")
  end
  
  def title_label
    label = doc.css("head title").inner_html.match(/\S+$/).to_s.gsub(/::/, ':').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_")
    
    if label.empty?
      label = doc.css("body div#fileHeader h1").inner_html
    end
    
    label = "\\label{doc:#{label.downcase}}"
  end
  
  def to_s
    @content ||= [
      title,
      title_label,
      texify("div#bodyContent div#description"),
      texify("div#section div#methods"),
    ].join("\n")
  end
  
  def write_file(f)
    File.open(f, 'w') {|f| f.write(to_s) }
  end
end