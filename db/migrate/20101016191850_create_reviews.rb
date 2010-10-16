class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :author_user_id # user who wrote the review
      t.integer :author_company_id
      t.integer :approved_by_id # user who approved the review to appear on the company's profile
      t.integer :company_id # the reviewed company
      t.text :text
      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
