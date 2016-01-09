class UpdateUser
  # update given user with give data. The data argument
  # is a hash object with these attributes:
  # username, email, password, first_name, last_name, gender, birthday,
  # avatar
  #
  # Assume that if a value in data is not empty, then it is
  # going to be valid to use it as the new user attribute
  #
  # Returns the user with new attributes if update successful;
  # Returns nil otherwise
  def self.call(user, data)
    # deal with everything but birthday, avatar, and password
    data.each_key do |key|
      if data[key].length > 0 and key.to_s != "birthday" and key.to_s != "password" and key.to_s != "avatar"
        user[key] = data[key]
      end
    end
    if data[:password].length > 0
      user.password = data[:password]
      user.password_confirmation = data[:password]
    end
    if data[:birthday].length > 0
      user[:birthday] = Date.strptime(data[:birthday], '%m/%d/%Y')
    end
    
    # only update the avatar if the data passed contains nonempty string
    avatar_data = JSON.parse(data[:avatar])
    if (avatar_data["front"].length == 0)
      avatar_data["front"] = user.avatar_json("front")
    end
    if (avatar_data["back"].length == 0)
      avatar_data["back"] = user.avatar_json("back")
    end
    user.avatar = avatar_data.to_json
    if user.save
      user
    else
      nil
    end
  end
end
