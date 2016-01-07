class GrabNotifications
  # Return an array of messages representing the
  # notifications
  def self.call(user)
    msgs = []
    user.notifications.sort_by(&:created_at).reverse.slice(0, 5).each do |notif|
      # check if the who_id is not equal to user's id
      msg = notif.message
      if msg[:who_id].to_s != user.id.to_s
        msgs << msg
      end
    end
    msgs
  end
end
