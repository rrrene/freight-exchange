class AddApiKeyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :api_key, :string
    User.all.each do |user|
      user.method("generate_api_key").call # since method is private
      user.save
    end
  end

  def self.down
    remove_column :users, :api_key
  end
end
