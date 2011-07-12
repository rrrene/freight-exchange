
namespace :app do
  namespace :notifications do
    desc "Generate notifications for the users."
    task :demo => :environment do
      User.where('login LIKE ?', 'demo_%').each do |current_user|
        puts current_user.name
        notification = current_user.current_notification
        arr = [Freight, LoadingSpace].map do |model|
          model.limit(5).order('created_at DESC').all
        end.flatten
        5.times do 
          notification << arr.rand
        end
        notification.close!
        #NotificationBuilder::Base.new(current_user).build!
      end
    end
  end
end