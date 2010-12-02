#!/usr/bin/env ruby -wKU

module Robot
  module Actions
    
    def approve_review
      Robot::Review.approve
      puts "# #{Robot::Review.all.size} Reviews"
    end
    
    def create_freight
      Robot::Freight.create
      puts "# #{Robot::Freight.all.size} Freights"
    end
    
    def create_loading_space
      Robot::LoadingSpace.create
      puts "# #{Robot::LoadingSpace.all.size} LoadingSpaces"
    end
    
    def create_review
      Robot::Review.create
      puts "# #{Robot::Review.all.size} Reviews"
    end
    
    def create_user
      Robot::User.create
      puts "# #{Robot::User.all.size} Users"
    end
    
    def delete_freight
    end
    
    def delete_loading_space
    end
    
    def delete_user
    end
    
    def edit_user
      Robot::User.edit
    end
  end
end