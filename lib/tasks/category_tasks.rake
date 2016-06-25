namespace :catg do
  task :generate_www => :environment do
    categories = ["Funny", "News", "Art & Photography", "Music", "Knowledge & Tips",
                  "Food", "Fashion", "Entertainment", "Sport", "Anime",
                  "Reading", "Travel", "Miscellenous",
                  "Technology", "Military", "Gaming"]
    categories.each do |name|
      Category.create!(name: name, subdomain: "www")
      print "."
    end
  end
end
