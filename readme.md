CODE24 Prototype for a Rail Transport Online Spot Exchange
==========================================================

This is the source code for a european rail transport online spot exchange. It is a regular Rails Web Application and a first prototype, developed by René Föhring during his research at the University of Duisburg-Essen. The prototype was originally developed as part of the CODE24 project.

Setup
-----

To set up this prototype, a basic knowledge and understanding of web development and rails applications is required. The Ruby on Rails framework and many helpful links can be found under http://rubyonrails.org

NOTE: The prototype has only been tested with ruby-1.8.7, therefore use of rvm is heavily recommended (.rvmrc file is present).

After checking out the app, database.yml needs to be created and configured (sample files for both sqlite and mysql are present in the config/ folder).

Afterwards:

    $ bundle
    $ rake db:create:all
    $ rake db:setup
    
The db:setup task might take a while since the db will be seeded with several thousands railway stations from across europe.

After the seeding is finished, the prototype can be started like any other Rails 3.0 app and a setup assistant will be shown to create an administrator account for the online spot exchange etc.

NOTE: The client has been originally developed using WEBrick as webserver, but thin or unicorn are recommended for performance reasons.