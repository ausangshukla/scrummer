class Ability
  include CanCan::Ability
  
  GUEST = User.new(role:"Guest", first_name:"John", last_name:"Doe")
  
  def initialize(user)

    if(!user)
      @user =  GUEST
    else
      @user = user
    end

    case @user.role

    when "Super User"
      can :manage, :all
    when *User::MEMBERS
      team_member_privilages
    when *User::MANAGERS
      manager_privilages
    when "Read Only"
      read_only_privilages
    else
      guest_privilages
    end

  end

  def guest_privilages
    
  end

  def user_privilages
    guest_privilages
    can [:manage], User, :id => @user.id    
    can [:show], Project
  end

  def team_member_privilages
    user_privilages
    can [:read], Project, :project_user_mappings=> {:user_id=>@user.id}
    can [:read], Sprint
    can [:read], Feature  
    can [:manage], Feature, :assigned_to => @user.id
    can [:read], Task
    can [:manage], Task, :assigned_to => @user.id
    can [:read], ProjectUserMapping
    can [:read], User
  end
  
  def manager_privilages    
    team_member_privilages
    can [:manage], Project, :project_user_mappings=> {:user_id=>@user.id, :role=>User::MANAGERS}
    can [:manage], Sprint, :project =>{ :project_user_mappings=> {:user_id=>@user.id, :role=>User::MANAGERS} }
    can [:manage], Feature, :project =>{ :project_user_mappings=> {:user_id=>@user.id, :role=>User::MANAGERS} }
    can [:manage], Task, :project =>{ :project_user_mappings=> {:user_id=>@user.id, :role=>User::MANAGERS} }
    can [:manage], ProjectUserMapping, :project =>{ :project_user_mappings=> {:user_id=>@user.id, :role=>User::MANAGERS} }
  end
    
  def read_only_privilages    
    can [:read], :all
    cannot [:manage], :all
  end
  

end

