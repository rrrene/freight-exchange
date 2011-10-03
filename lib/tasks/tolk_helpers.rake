


namespace :tolk do
  desc "..."
  task :clean_sync => :environment do
    %w(errors.messages.% errors.format date.% datetime.% time.% number.% flash.actions.%).each do |str|
      Tolk::Phrase.where("key LIKE ?", str).each(&:destroy)
    end
  end
end
