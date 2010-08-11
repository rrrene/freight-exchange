Diplom - Rails
==============

To-Dos
--------------
* Lokalisierung - HowTos angucken
* Tabelle für Bahnhöfe
* Tabelle für Regionen und Länder (aber: hier müssten die Bahnhöfe den Regionen und Ländern zugeordnet werden)
* Tabelle für Güterarten
* Tabelle für Fahrzeugtypen

Woraus besteht ein Inserat?
---------------------------

* Ladezeitpunkt, Ladeort (1), Region, Land (2)
* Zielzeitpunkt, Zielort, Region, Land 
* Güterart, Fahrzegutyp (3)
* Lademeter, Gewicht
* Dienstleister, Sonstiges

(1)  Bahnhöfe sind nicht frei eintragbar.

(2)  Regionen und Länder müssen mit den Bahnhöfen verdrahtet werden und ebenfalls nicht frei eintragbar sein.

(3)  Fraglich ist, ob bspw. Güterart und Fahrzeugtyp wirklich Objekte in anderen Tabellen sind oder nicht doch Freitext-Felder, da es unzählige Güterarten in der Transport-Statistik gibt und diese wahrscheinlich auf von Land zu Land andere Identifikationsnummern etc. haben.

### Tabellen:
  
  search_recordings
    t.integer :user_id
    t.integer :company_id
    t.integer :results
    t.string :query
  
  user_role
    name: string # e.g. "company_admin"
    
  postings
    t.string :type
    t.datetime :origin_date
    t.datetime :destination_date
    t.integer :origin_station_id
    t.integer :destination_station_id
    
    t.string :goods_type
    t.string :wagon_type
    
    t.integer :loading_meter
    t.integer :weight
    
    t.string :contractor
    t.text :misc


  stations
    t.string :name
    t.integer :region_id    # optional
    t.integer :country_id   # optional, intented to provide better search results
    
  regions
    t.string :name
    t.integer :country_id
    
  countries
    t.string :name
    t.string :iso
    
    [
      {:iso => 'de', :name => 'Germany'},
      {:iso => 'ch', :name => 'Switzerland'},
      {:iso => 'fr', :name => 'France'},
      {:iso => 'it', :name => 'Italy'},
      {:iso => 'nl', :name => 'Netherlands'},
    ]
