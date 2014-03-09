namespace :scrummer do    
  
  require "faker"
  require 'digest/sha1'  
  # require 'factory_girl'  
  # require File.expand_path("spec/factories.rb")
  
  
   
  
  desc "Cleans p DB - DELETES everything -  watch out" 
  task :emptyDB => :environment do
  	User.delete_all
  	Project.delete_all
  	ProjectUserMapping.delete_all
  	Feature.delete_all
  	Sprint.delete_all
  	Task.delete_all
  	Delayed::Job.delete_all
  end
  
  
  
  desc "generates fake users for testing" 
  task :generateFakeUsers => :environment do
    
    begin    
      
		   		(1..20).each do |j|    
			        u = FactoryGirl.build(:team_member)
	            u.save!
		          puts "User #{u.id}"              
         	end	    
          (1..5).each do |j|    
              u = FactoryGirl.build(:manager)
              u.save!
              puts "User #{u.id}"              
          end     

    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
    
  end  
  
  desc "generates fake users for testing" 
  task :generateFakeAdmin => :environment do
    
    begin    
      
      u = FactoryGirl.build(:user, email: "admin@scrummer.com", password: "admin@scrummer.com", role: "Super User")
      u.save
      puts u.to_xml              
      
      u = FactoryGirl.build(:user, email: "scrum_master@scrummer.com", password: "scrum_master@scrummer.com", role: User::MANAGERS[0])
      u.save
      puts u.to_xml
      
      u = FactoryGirl.build(:user, email: "team_member@scrummer.com", password: "team_member@scrummer.com", role: User::MEMBERS[0])
      u.save
      puts u.to_xml
      

    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
    
  end  
  

  task :generateFakeProjects => :environment do
    
    begin    
      
          
          (1..10).each do |j|
              start_date = Date.today - 1.month - rand(2).months    
              p = FactoryGirl.build(:project, start_date: start_date, end_date: start_date + 90.days + rand(90).days)
              p.save
              puts "Project #{p.id}" 
              user_ids = User.team_members.collect(&:id).shuffle
              (1..4).each do |i|
                ProjectUserMapping.create(project_id:p.id, user_id:user_ids[i], role: User::MEMBERS[0])
              end             
              manager_ids = User.managers.collect(&:id).shuffle
              ProjectUserMapping.create(project_id:p.id, user_id:manager_ids[0], role: User::MANAGERS[0])              
          end 

    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
    
  end
  
  task :generateFakeSprints => :environment do
    
    begin    
          
          Project.all.each do |p|
             no_of_sprints = (p.end_date - p.start_date).to_i / 30 
             start_date = p.start_date
             
             (1..no_of_sprints).each do |j|    
                s = FactoryGirl.build(:sprint, iteration:j, project_id: p.id, start_date:start_date, end_date: start_date + 30.days)
                s.save!
                puts "Sprint #{s.id}"                
                start_date = s.end_date + 1.day
              end 
          end
    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
    
  end
  
  task :generateFakeFeatures => :environment do
    
    begin    
          Project.all.each do |p|
             user_ids = p.users.collect(&:id)
             sprint_ids = p.sprints.collect(&:id) 
             (1..10).each do |j|    
                f = FactoryGirl.build(:feature, project_id: p.id, sprint_id: sprint_ids[rand(sprint_ids.length)], assigned_to: user_ids[rand(user_ids.length)])
                f.save!               
                puts "Feature #{f.id}" 
            end 
          end
    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
    
  end
  
  
  task :generateFakeTasks => :environment do
    
    begin    
          Feature.all.each do |f|
             user_ids = f.project.users.collect(&:id)
             (1..10).each do |j|    
                t = FactoryGirl.build(:task, project_id: f.project_id, 
                                      feature_id: f.id, assigned_to: user_ids[rand(user_ids.length)],
                                      updated_at: (f.sprint.start_date + j.days) )
                t.save!               
                puts "Task #{t.id}" 
            end 
            
            (11..20).each do |j|    
                t = FactoryGirl.build(:task, project_id: f.project_id, actual_hours: 0, 
                                      feature_id: f.id, assigned_to: user_ids[rand(user_ids.length)],
                                      updated_at: (f.sprint.start_date + j.days) )
                t.save!               
                puts "Task #{t.id}" 
            end
          end
    rescue Exception => exception
      puts exception.backtrace.join("\n")
      raise exception
    end
    
  end        
  
  desc "Generating all Fake Data"
  task :generateFakeAll => [:emptyDB, :generateFakeUsers, :generateFakeAdmin, :generateFakeProjects, :generateFakeSprints, :generateFakeFeatures, :generateFakeTasks ] do
    puts "Generating all Fake Data"
  end
  
	
 	
end