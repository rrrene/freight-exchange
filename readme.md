Prototype for an Online Rail Transport Spot Exchange
==========================================================

This is the source code for an european online rail transport spot exchange. It is a regular Rails Web Application and a first prototype, developed by René Föhring during his research at the University of Duisburg-Essen. The prototype was originally developed as part of the CODE24 project.

## Setup

### Rails

To set up this prototype, a basic knowledge and understanding of web development and rails applications is required.

The Ruby on Rails framework and many helpful links can be found under http://rubyonrails.org

### Ruby

As a Rails 3.0 app, the prototype naturally requires RubyGems and Bundler to be installed.

Please note: The use of rvm is heavily recommended (.rvmrc file is present). The app has only been tested with ruby-1.8.7 (patch levels 299 and 357 to be precise).

### Database

The prototype works properly with SQLite as well as MySQL.

After checking out the app, database.yml needs to be created and configured (sample files for both sqlite and mysql configurations are present in the config/ folder).

### Installation

After database.yml was created, simply run:

    $ bundle
    $ rake db:create:all
    $ rake db:setup
    
Please note: The db:setup task might take a while since the db will be seeded with several thousands of european railway stations.

### Finishing up

After the seeding is finished, the prototype can be started like any other Rails 3.0 app and a setup assistant will be shown to create an administrator account for the online spot exchange etc.

Please note: The client has been originally developed using WEBrick as webserver, but servers like thin or unicorn are recommended for performance reasons.
