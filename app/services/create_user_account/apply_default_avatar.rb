# Warning: Currently ApplyDefaultAvatar is not used. If
# a user does not have an avatar on a side, the path
# to default avatar will be supplied.
#
# See /app/helpers/user_helper.rb.

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
