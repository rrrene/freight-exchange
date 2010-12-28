%w(freight loading_space).each do |file|
  load "script/robot/#{file}.rb"
end

module Demo
  class Base
    class << self
      def create(user = nil)
        klass = "::#{base_name}".constantize
        attributes = factory_attributes
        unless user.nil?
          attributes[:user_id] = user.id
          attributes[:company_id] = user.company.id
        end
        object = klass.new(attributes)
        object.save
        object
      end
      
      def base_name
        self.to_s.split('::').last
      end
      
      def factory_attributes
        Factory.attributes_for("Robot::#{base_name}")
      end
    end
  end
  
  class Freight < Base; end
  class LoadingSpace < Base; end
  
  class Company < Base
    class << self
      def create
        company = ::Company.where(:name => factory_attributes[:name]).first
        company ||= ::Company.create(factory_attributes)
        demo_user_attributes.each do |attr|
          create_or_find(attr.merge(:company_id => company.id))
        end
        if company_admin = company.users.first
          company_admin.user_roles << ::UserRole[:company_admin]
        end
        
        10.times do
          Demo::Freight.create(company)
        end
        
        company
      end

      def create_or_find(attributes = {})
        user = User.new(attributes)
        if user.save 
          user
        else
          ::User.where(:login => user.login).first
        end
      end

      def factory_attributes
        {
          :name => "Demontage Sprenkler AG",
          :address => "Wallstr. 56-58",
          :zip => "44567",
          :city => "Bochum",
          :country => 'Deutschland',
          :phone => '+49 (0) 234 569986-0',
          :fax => '+49 (0) 234 569986-55',
          :email => 'demontage@example.org',
          :website => 'example.org',
        }
      end

      def demo_user_attributes
        [
          {
            :login => 'demo_user',
            :email => 'm.sprenkler@example.org',
            :password => user_pwd,
            :password_confirmation => user_pwd,
            :person_attributes => {
              :gender => 'male',
              :first_name => 'Maximilian',
              :last_name => 'Sprenkler',
              :job_description => 'Chief Executive Officer',
              :phone => '+49 (0) 234 569986-1',
              :fax => '+49 (0) 234 569986-55',
              :website => 'example.org/team/m.sprenkler',
            },
          },
          {
            :login => 'demo_user2',
            :email => 'b.sprenkler@example.org',
            :password => user_pwd,
            :password_confirmation => user_pwd,
            :person_attributes => {
              :gender => 'female',
              :first_name => 'Bettina',
              :last_name => 'Sprenkler',
              :job_description => 'Chief Financial Officer',
              :phone => '+49 (0) 234 569986-2',
              :fax => '+49 (0) 234 569986-55',
              :website => 'example.org/team/b.sprenkler',
            },
          },
          {
            :login => 'demo_user3',
            :email => 'p.krause@example.org',
            :password => user_pwd,
            :password_confirmation => user_pwd,
            :person_attributes => {
              :gender => 'male',
              :first_name => 'Peter',
              :last_name => 'Krause',
              :job_description => 'Senior Logistics Manager',
              :phone => '+49 (0) 234 569986-3',
              :fax => '+49 (0) 234 569986-55',
              :website => 'example.org/team/p.krause',
            },
          },
          {
            :login => 'demo_user4',
            :email => 'm.kowalla@example.org',
            :password => user_pwd,
            :password_confirmation => user_pwd,
            :person_attributes => {
              :gender => 'male',
              :first_name => 'Martin',
              :last_name => 'Kowalla',
              :job_description => 'Senior Logistics Manager',
              :phone => '+49 (0) 234 569986-4',
              :fax => '+49 (0) 234 569986-55',
              :website => 'example.org/team/m.kowalla',
            },
          },
          {
            :login => 'demo_user5',
            :email => 'a.baumann@example.org',
            :password => user_pwd,
            :password_confirmation => user_pwd,
            :person_attributes => {
              :gender => 'female',
              :first_name => 'Anette',
              :last_name => 'Baumann',
              :job_description => 'Logistics Trainee',
              :phone => '+49 (0) 234 569986-5',
              :fax => '+49 (0) 234 569986-55',
              :website => 'example.org/team/a.baumann',
            },
          },
        ]
      end

      def user_pwd
        'admin'
      end
    end
  end
end
