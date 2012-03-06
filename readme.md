CODE24 Prototype for a Rail Transport Online Spot Exchange
==========================================================

Setup
-----

You have to create your database.yml (sample files for sqlite and mysql present).

Afterwards:

    $ bundle
    $ rake db:create:all
    $ rake db:setup
    
The setup might take a while since the db will be seeded with several thousands railway stations from across europe.

After the seeding is finished, the prototype can be started like any other Rails 3.0 app and a setup assistant will be shown to create an administrator account for the online spot exchange etc.

