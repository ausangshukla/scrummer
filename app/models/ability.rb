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
    when "Team Member"
      team_member_privilages
    when "Scrum Master"
      scrum_master_privilages
    when "Read Only"
      read_only_privilages
    else
      guest_privilages
    end

  end

  def guest_privilages
    # Anyone can read or register a Company
    can [:read], Project
  end

  def user_privilages
    guest_privilages
    can [:manage], User, :id => @user.id    
  end

  def team_member_privilages
    user_privilages
    can [:manage], Project
    can [:manage], Sprint
    can [:manage], Feature
    can [:manage], Task
    can [:manage], ProjectUserMapping
  end
  
  def scrum_master_privilages    
    team_member_privilages
  end
    
  def read_only_privilages    
    emp_privilages
  end
  

end

