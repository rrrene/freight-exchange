module Seed
  USER_ROLES = [
    {:name => 'company_admin'},
    {:name => 'company_employee'},
    {:name => 'company_intern'},
    {:name => 'administrator'},
    {:name => 'support'},
  ]
    
  USERS = []
  # TODO: should we seed users? since we have robots now, i mean...
  [
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
end