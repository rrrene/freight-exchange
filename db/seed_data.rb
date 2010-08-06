module Seed
  USERS = [
    {
      :login => 'freight_supplier',
      :email => 'freight_supplier@example.org',
      :password => 'asdf', :password_confirmation => 'asdf',
    },
    {
      :login => 'loading_space_supplier',
      :email => 'loading_space_supplier@example.org',
      :password => 'asdf', :password_confirmation => 'asdf',
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
      {:name => 'Bochum Hbf', :regions => ['Ruhr', 'Westfalen']},
      {:name => 'Essen Hbf', :regions => ['Ruhr', 'Westfalen']},
      {:name => 'Dortmund Hbf', :regions => ['Ruhr', 'Westfalen']},
    ],
    :nl => [
      {:name => 'Utrecht Centraal', :regions => ['Utrecht']},
    ]
  }
end