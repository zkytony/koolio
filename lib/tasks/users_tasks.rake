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
end
