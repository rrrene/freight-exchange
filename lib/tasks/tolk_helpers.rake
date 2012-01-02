


namespace :tolk do
  desc "..."
  task :clean_sync => :environment do
    verboten = %w(errors.messages.% errors.format date.% datetime.% time.% number.% flash.actions.% search.advanced.keyword_is)
    verboten.each do |str|
      Tolk::Phrase.where("key LIKE ?", str).each(&:destroy)
    end
  end
end
