class NotificationBuilder
  attr_accessor :user, :notification, :timestamp
  def initialize(_user)
    self.user = _user
    self.notification = user.current_notification
    self.timestamp = user.last_notification.closed_at.full? || 1.week.ago
    puts "user:#{user.id}"
    puts "  using timestamp #{timestamp}"
  end

  def build!
    puts "  postings: #{postings.count}"
    postings.each do |posting|
      puts "    Posting: #{posting.pretty_id}"
      puts "    matches > 0: #{matching_recordings_greater_than(posting, 0).count}"
      matching_recordings_greater_than(posting, 0).each do |matching_recording|
        self.notification << posting
      end
    end
    notification.close!
  end

  private

  def matching_recordings_greater_than(posting, result)
    arel = MatchingRecording.where('updated_at > ?', timestamp)
    if posting.is_a?(Freight)
      arel = arel.where(:a_type => posting.class.to_s, :a_id => posting.id)
    else
      arel = arel.where(:b_type => posting.class.to_s, :b_id => posting.id)
    end
    arel.where('result >= ?', result)
  end

  def postings
    @postings ||= begin
      postings = []
      postings << user.company.freights.where('updated_at > ?', timestamp).all
      postings << user.company.loading_spaces.where('updated_at > ?', timestamp).all
      postings.flatten
    end
  end
end

namespace :app do
  namespace :notifications do
    desc "Generate notifications for the users."
    task :create => :environment do
      #User.all.each do |current_user|
        current_user = User.find(20)
        NotificationBuilder.new(current_user).build!
      #end
    end
  end
end