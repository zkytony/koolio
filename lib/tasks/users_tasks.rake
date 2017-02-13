namespace :user do
  task :activate_all => :environment do
    User.find_each(batch_size: 5000) do |user|
      if !user.activated
        token = SecureRandom.base58(24)
        user.update_attributes(activation_digest: token)
        user.activate(token)
        print "."
      else
        print "S"
      end
    end
    puts "Success"
  end

  task :remove_user, [:un] => :environment do |t, args|
    user = User.find_by(username: args[:un])
    User.delete_account(user.id)
    puts "Done."
  end
end
