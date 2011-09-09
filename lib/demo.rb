%w(freight loading_space).each do |file|
  load "script/robot/#{file}.rb"
end

module Demo
  # The Base class is inherited by other classes (e.g. Demo::Freight)
  # and provides basic functionality to dynamically create the demo
  # company and its users, freights, reviews etc.
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
        company = instance
        demo_user_attributes.each do |attr|
          user = create_or_find(attr.merge(:company_id => company.id))
          user.user_roles << ::UserRole[:company_employee]
          user.person.update_attribute(:locale, 'de')
        end
        if company_admin = company.users.first
          company_admin.user_roles << ::UserRole[:company_admin]
        end
        company
      end
      
      def create_postings(count = 5)
        company = instance
        count.times do
          more_freights = company.freights.count > company.loading_spaces.count
          model = more_freights ? Demo::LoadingSpace : Demo::Freight
          model.create(company)
        end
      end
      
      def fake_notifications(count = 5)
        instance.users.each do |current_user|
          notification = current_user.current_notification
          arr = [::Freight, ::LoadingSpace].map do |model|
            model.limit(5).order('created_at DESC').all
          end.flatten
          count.times do 
            notification << arr.rand
          end
          notification.close!
        end
      end
      
      def instance
        company = ::Company.where(:name => factory_attributes[:name]).first
        company ||= ::Company.create(factory_attributes)
      end
      
      def setup(options)
        company = create
        create_postings(options[:postings].to_i)
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
            :login => 'demo_user_admin',
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
            :login => 'demo_user02',
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
            :login => 'demo_user03',
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
            :login => 'demo_user04',
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
            :login => 'demo_user05',
            :email => 'a.baumann@example.org',
            :password => user_pwd,
            :password_confirmation => user_pwd,
            :person_attributes => {
              :gender => 'female',
              :first_name => 'Anette',
              :last_name => 'Baumann',
              :job_description => 'Junior Logistics Manager',
              :phone => '+49 (0) 234 569986-5',
              :fax => '+49 (0) 234 569986-55',
              :website => 'example.org/team/a.baumann',
            },
          },
          {
            :login => 'demo_user06',
            :email => 'b.baumann@example.org',
            :password => user_pwd,
            :password_confirmation => user_pwd,
            :person_attributes => {
              :gender => 'male',
              :first_name => 'Bernhard',
              :last_name => 'Baumann',
              :job_description => 'Junior Logistics Manager',
              :phone => '+49 (0) 234 569986-6',
              :fax => '+49 (0) 234 569986-55',
              :website => 'example.org/team/b.baumann',
            },
          },
          {
            :login => 'demo_user07',
            :email => 'j.etterich@example.org',
            :password => user_pwd,
            :password_confirmation => user_pwd,
            :person_attributes => {
              :gender => 'male',
              :first_name => 'Jan',
              :last_name => 'Etterich',
              :job_description => 'Junior Logistics Manager',
              :phone => '+49 (0) 234 569986-7',
              :fax => '+49 (0) 234 569986-55',
              :website => 'example.org/team/j.etterich',
            },
          },
          {
            :login => 'demo_user08',
            :email => 'm.mueller@example.org',
            :password => user_pwd,
            :password_confirmation => user_pwd,
            :person_attributes => {
              :gender => 'male',
              :first_name => 'Marius',
              :last_name => 'Müller',
              :job_description => 'Logistics Trainee',
              :phone => '+49 (0) 234 569986-0',
              :fax => '+49 (0) 234 569986-55',
              :website => 'example.org/team/trainees',
            },
          },
          {
            :login => 'demo_user09',
            :email => 'c.ampel@example.org',
            :password => user_pwd,
            :password_confirmation => user_pwd,
            :person_attributes => {
              :gender => 'female',
              :first_name => 'Caroline',
              :last_name => 'Ampel',
              :job_description => 'Logistics Trainee',
              :phone => '+49 (0) 234 569986-0',
              :fax => '+49 (0) 234 569986-55',
              :website => 'example.org/team/trainees',
            },
          },
          {
            :login => 'demo_user10',
            :email => 'k.fischer@example.org',
            :password => user_pwd,
            :password_confirmation => user_pwd,
            :person_attributes => {
              :gender => 'female',
              :first_name => 'Kerstin',
              :last_name => 'Fischer',
              :job_description => 'Logistics Trainee',
              :phone => '+49 (0) 234 569986-0',
              :fax => '+49 (0) 234 569986-55',
              :website => 'example.org/team/trainees',
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
