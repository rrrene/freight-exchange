module Seed
  USER_ROLES = [
    {:name => 'company_admin'},
    {:name => 'company_employee'},
    {:name => 'company_intern'},
    {:name => 'administrator'},
  ]
    
  USERS = [
    {
      :login => 'freight_supplier',
      :email => 'freight_supplier@example.org',
      :password => 'asdf', :password_confirmation => 'asdf',
      :person_attributes => {
        :gender => 'male',
        :first_name => 'Karlo',
        :last_name => 'Kaufmann'
      },
      :company_attributes => {
        :name => 'Essener Geldschrankfabrik AG',
        :phone => '+49 201 555 1001',
        :email => 'some@example.org',
        :website => 'example.org',
      }
    },
    {
      :login => 'loading_space_supplier',
      :email => 'loading_space_supplier@example.org',
      :password => 'asdf', :password_confirmation => 'asdf',
      :person_attributes => {
        :gender => 'male',
        :first_name => 'Wilhelm',
        :last_name => 'Wagonbesitzer'
      },
      :company_attributes => {
        :name => 'DB Schenker Logistics',
        :phone => '+49 231 555 1001',
        :email => 'db-logistics@example.org',
        :website => 'example.org',
      }
    },
  ]
  
  COUNTRIES = [
    {:iso => 'de', :name => 'Germany'},
    {:iso => 'ch', :name => 'Switzerland'},
    {:iso => 'fr', :name => 'France'},
    {:iso => 'it', :name => 'Italy'},
    {:iso => 'nl', :name => 'Netherlands'},
  ]
  
  REGIONS = {
    :de => [
      {:name => 'Rhein-Neckar'},
      {:name => 'Rhein-Main'},
      {:name => 'Ruhr'},
      {:name => 'Westfalen'},
    ],
    :nl => [
      {:name => 'Utrecht'},
    ]
  }
  
  STATIONS = {
    :de => [
      {:name => 'Bochum Hbf', :regions => ['Ruhr', 'Westfalen'],
        :address => "Kurt-Schumacher-Platz",
        :zip => "44787",
        :city => "Bochum",
      },
      {:name => 'Essen Hbf', :regions => ['Ruhr', 'Westfalen'],
        :address => "Am Hauptbahnhof",
        :zip => "45128",
        :city => "Essen",
      },
      {:name => 'Dortmund Hbf', :regions => ['Ruhr', 'Westfalen'],
        :address => "Bahnhofstr.",
        :zip => "44137",
        :city => "Dortmund",
      },
    ],
    :nl => [
      {:name => 'Utrecht Centraal', :regions => ['Utrecht']},
    ]
  }
end