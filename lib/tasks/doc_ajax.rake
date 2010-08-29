namespace :doc do
  desc "Generate ajax documentation for the application."
  Rake::RDocTask.new("ajax") { |rdoc|
    rdoc.rdoc_dir = 'doc/ajax'
    rdoc.title    = "Rails Application Documentation"
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.options << '--charset' << 'utf-8'
    rdoc.options << '--fmt' << 'ajax'
    rdoc.main = 'doc/README_FOR_APP'
    rdoc.rdoc_files.include('doc/README_FOR_APP')
    rdoc.rdoc_files.include('app/**/*.rb')
    rdoc.rdoc_files.include('lib/**/*.rb')
  }
end
