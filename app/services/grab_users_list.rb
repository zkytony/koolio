class GrabUsersList
  # if user is nil and type is 
  def self.call(user, type)
    case type
    when "followers"
      grab_followers(user)
    when "followings"
      grab_followings(user)
    when "mutual_followers"
      grab_mutual_followers(user)
    else
      nil
    end
  end

  def self.grab_followers(user)
    user.followers
  end

  def self.grab_followings(user)
    user.followings
  end

  def self.grab_mutual_followers(user)
    user.mutual_follows
  end
end
