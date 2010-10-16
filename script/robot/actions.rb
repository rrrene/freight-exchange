#!/usr/bin/env ruby -wKU

module Robot
  module Actions
    def create_freight
      Robot::Freight.create
      puts "# #{Robot::Freight.all.size} Freights"
    end
    
    def create_loading_space
      Robot::LoadingSpace.create
      puts "# #{Robot::LoadingSpace.all.size} LoadingSpaces"
    end
    
    def create_review
    end
    
    def approve_review
    end
    
    def create_user
    end
    
    def delete_user
    end
    
    def edit_user
    end
  end
end