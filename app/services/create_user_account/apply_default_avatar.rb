class CreateUserAccount
  class ApplyDefaultAvatar
    # Apply the default avatar to the user
    def self.call(user)
      default_avatar = {
        front: "/assets/default-profile.svg",
        back: "/assets/default-profile.svg"
      }
      user.avatar = default_avatar.to_json
      user.save!
    end
  end
end
