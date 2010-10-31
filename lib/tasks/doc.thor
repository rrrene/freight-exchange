#!/usr/bin/env ruby -wKU

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
  method_options %w(all -a) => false
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
      unless tex.empty? && !options[:all]
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
  
  desc "schema", "Parses the schema.rb file."
  def schema
    schema_file = File.join(rails_root, 'db', 'schema.rb')
    content = File.read(schema_file)
    @table, @tables = nil, {}
    content.each do |line|
      if line =~ /create_table/
        @table = line.scan(/create_table\ \"([^\"]+)\"/).to_s
        @tables[@table] = []
      else
        arr = line.scan(/t\.(string|text|integer|float|boolean)\s+\"([^\"]+)\"/).flatten
        unless arr.empty?
          @tables[@table] << {:name => arr[1], :type => arr[0]}
        end
      end
    end
    @tables.each do |table, fields|
      @table, @fields = table, fields
      @fields.each_with_index do |field_hash, i|
        name = field_hash[:name]
        field_hash = field_hash.merge(schema_hash[@table][name.intern])
        field_hash.each do |key, value|
          field_hash[key] = escape_for_template(value)
        end
        @fields[i] = field_hash
      end
      template "lib/tasks/templates/table.tex.erb", "doc/tex/schema/#{table}.tex", template_options
      success "#{table} generated"
    end
    #puts "{"
    #@tables.each do |table, fields|
    #  @table, @fields = table, fields
    #  puts %Q(  "#{@table}" => {)
    #  fields.each do |field|
    #    name = field[:name].gsub('\_', '_')
    #    puts %Q(    :#{name} => {:description => "", :example => ""},)
    #  end
    #  puts "  },"
    #end
    #puts "}"
  end
  
  private
  
  def escape_for_template(obj)
    obj.to_s.gsub('_', '\_')
  end
  
  def rails_root
    File.join(File.dirname(__FILE__), '..', '..')
  end
  
  def doc_path
    File.join(rails_root, 'doc')
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
  
  def schema_hash
    {
      "user_roles" => {
        :name => {:description => "Name der Benutzerrolle", :example => "company_admin"},
      },
      "regions_stations" => {
        :region_id => {:description => "", :example => ""},
        :station_id => {:description => "", :example => ""},
      },
      "regions" => {
        :name => {:description => "Name der Region", :example => ""},
        :country_id => {:description => "Verweis auf das Land, zum dem die Region gehört", :example => 1},
      },
      "countries" => {
        :name => {:description => "", :example => ""},
        :iso => {:description => "", :example => ""},
      },
      "stations" => {
        :name => {:description => "", :example => ""},
        :country_id => {:description => "", :example => ""},
        :address => {:description => "", :example => ""},
        :address2 => {:description => "", :example => ""},
        :zip => {:description => "", :example => ""},
        :city => {:description => "", :example => ""},
      },
      "localized_infos" => {
        :item_type => {:description => "", :example => ""},
        :item_id => {:description => "", :example => ""},
        :name => {:description => "", :example => ""},
        :lang => {:description => "", :example => ""},
        :text => {:description => "", :example => ""},
      },
      "simple_searches" => {
        :item_type => {:description => "", :example => ""},
        :item_id => {:description => "", :example => ""},
        :text => {:description => "", :example => ""},
      },
      "search_recordings" => {
        :user_id => {:description => "Verweis auf den Benutzer, dem das Objekt gehört.", :example => 1},
        :query => {:description => "", :example => ""},
        :results => {:description => "", :example => ""},
        :parent_id => {:description => "", :example => ""},
        :result_type => {:description => "", :example => ""},
        :result_id => {:description => "", :example => ""},
      },
      "loading_spaces" => {
        :user_id => {:description => "Verweis auf den Benutzer, dem das Objekt gehört.", :example => 1},
        :company_id => {:description => "Verweis auf die Firma, zu der das Objekt gehört.", :example => 1},
        :origin_site_info_id => {:description => "", :example => ""},
        :destination_site_info_id => {:description => "", :example => ""},
        :weight => {:description => "", :example => ""},
        :loading_meter => {:description => "", :example => ""},
        :hazmat => {:description => "", :example => ""},
        :transport_type => {:description => "", :example => ""},
      },
      "companies" => {
        :name => {:description => "Name der Firma", :example => "Mustermann GmbH"},
        :contact_person => {:description => "", :example => ""},
        :phone => {:description => "", :example => ""},
        :fax => {:description => "", :example => ""},
        :mobile => {:description => "", :example => ""},
        :email => {:description => "", :example => ""},
        :website => {:description => "", :example => ""},
        :address => {:description => "", :example => ""},
        :address2 => {:description => "", :example => ""},
        :zip => {:description => "", :example => ""},
        :city => {:description => "", :example => ""},
        :country => {:description => "", :example => ""},
        :misc => {:description => "", :example => ""},
      },
      "site_infos" => {
        :contractor => {:description => "", :example => ""},
        :name => {:description => "", :example => ""},
        :address => {:description => "", :example => ""},
        :address2 => {:description => "", :example => ""},
        :zip => {:description => "", :example => ""},
        :city => {:description => "", :example => ""},
        :country => {:description => "", :example => ""},
        :side_track_available => {:description => "", :example => ""},
        :track_number => {:description => "", :example => ""},
      },
      "recordings" => {
        :item_type => {:description => "", :example => ""},
        :item_id => {:description => "", :example => ""},
        :action => {:description => "", :example => ""},
        :diff => {:description => "", :example => ""},
        :user_id => {:description => "Verweis auf den Benutzer, dem das Objekt gehört.", :example => 1},
        :company_id => {:description => "Verweis auf die Firma, zu der das Objekt gehört.", :example => 1},
      },
      "matching_recordings" => {
        :a_type => {:description => "", :example => ""},
        :a_id => {:description => "", :example => ""},
        :b_type => {:description => "", :example => ""},
        :b_id => {:description => "", :example => ""},
        :result => {:description => "", :example => ""},
      },
      "reviews" => {
        :author_user_id => {:description => "", :example => ""},
        :author_company_id => {:description => "", :example => ""},
        :approved_by_id => {:description => "", :example => ""},
        :company_id => {:description => "Verweis auf die Firma, zu der das Objekt gehört.", :example => 1},
        :text => {:description => "", :example => ""},
      },
      "users" => {
        :login => {:description => "", :example => ""},
        :email => {:description => "", :example => ""},
        :crypted_password => {:description => "", :example => ""},
        :password_salt => {:description => "", :example => ""},
        :persistence_token => {:description => "", :example => ""},
        :single_access_token => {:description => "", :example => ""},
        :perishable_token => {:description => "", :example => ""},
        :login_count => {:description => "", :example => ""},
        :failed_login_count => {:description => "", :example => ""},
        :current_login_ip => {:description => "", :example => ""},
        :last_login_ip => {:description => "", :example => ""},
        :company_id => {:description => "Verweis auf die Firma, zu der der Benutzer gehört.", :example => 1},
        :person_id => {:description => "Verweis auf die Person, zu der der Benutzer gehört.", :example => ""},
        :api_key => {:description => "Alphanumberischer Schlüssel zur Ansteuerung der XML/JSON-API", :example => "55024db979499d5568f0859d046da09f47234a74"},
      },
      "people" => {
        :first_name => {:description => "Vorname", :example => "Max"},
        :last_name => {:description => "Nachname", :example => "Mustermann"},
        :gender => {:description => "Geschlecht", :example => "male"},
        :job_description => {:description => "Dienstbezeichnung", :example => "Vertriebsleiter Nord"},
        :phone => {:description => "Festnetznummer", :example => "0123-5436895"},
        :fax => {:description => "Faxnummer", :example => "0123-5436896"},
        :mobile => {:description => "Mobilfunknummer", :example => "0123-5436897"},
        :email => {:description => "E-Mail-Adresse", :example => "max.mustermann@example.org"},
        :website => {:description => "URL der Website", :example => "http://www.example.org/"},
        :locale => {:description => "Sprache, in der die Person die Benutzeroberfläche nutzt", :example => "de"},
      },
      "user_roles_users" => {
        :user_id => {:description => "Verweis auf den Benutzer, dem das Objekt gehört.", :example => 1},
        :user_role_id => {:description => "", :example => ""},
      },
      "freights" => {
        :user_id => {:description => "Verweis auf den Benutzer, dem das Objekt gehört.", :example => 1},
        :company_id => {:description => "Verweis auf die Firma, zu der das Objekt gehört.", :example => 1},
        :origin_site_info_id => {:description => "", :example => ""},
        :destination_site_info_id => {:description => "", :example => ""},
        :weight => {:description => "Gewicht der Fracht (in t)", :example => 50},
        :loading_meter => {:description => "Lademeter", :example => 30},
        :hazmat => {:description => "Ist das Gut ein Gefahrgut?", :example => true},
        :transport_type => {:description => "", :example => ""},
        :wagons_provided_by => {:description => "Wer stellt die Wagen bereit?", :example => ""},
        :desired_proposal_type => {:description => "Welche Art von Angebot wird gewünscht?", :example => ""},
      },
      "app_configs" => {
        :name => {:description => "Name der Konfigurationsvariable", :example => "language"},
        :value => {:description => "Wert der Konfigurationsvariable", :example => "de"},
      },
    }
  end
end