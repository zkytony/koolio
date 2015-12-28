class UpdateUser
  # update given user with give data. The data argument
  # is a hash object with these attributes:
  # username, email, password, first_name, last_name, gender, birthday 
  #
  # Assume that if a value in data is not empty, then it is
  # going to be valid to use it as the new user attribute
  def self.call(user, data)
    # deal with everything but birthday and password
    data.each_key do |key|
      if data[key].length > 0 and key.to_s != "birthday" and key.to_s != "password"
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

    puts user.inspect
    user.save!
  end
end
