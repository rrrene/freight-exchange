
namespace :app do
  namespace :notifications do
    desc "Generate notifications for the users."
    task :create => :environment do
      puts "+-#{'-'.*(5)}-+-#{'-'.*(25)}-+-#{'-'.*(10)}-+"
      puts "| #{'User'.ljust(5)} | #{'Timestamp'.ljust(25)} | #{'Items'.ljust(10)} |"
      puts "+-#{'-'.*(5)}-+-#{'-'.*(25)}-+-#{'-'.*(10)}-+"
      User.all.each do |current_user|
        NotificationBuilder::Factory.new(current_user).build!
      end
      puts "+-#{'-'.*(5)}-+-#{'-'.*(25)}-+-#{'-'.*(10)}-+"
    end
  end
end