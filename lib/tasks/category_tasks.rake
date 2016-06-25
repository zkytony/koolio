namespace :catg do
  task :generate_www => :environment do
    categories = ["Funny",
                  "News",
                  "Entertainment",
                  "Sport",
                  "Food",
                  "Knowledge & Tips",
                  "Art & Photography",
                  "Music",
                  "Anime",
                  "Fashion",
                  "Gaming",
                  "Technology",
                  "Reading",
                  "Travel",
                  "Military",
                  "Miscellenous"]
    categories.each do |name|
      Category.create!(name: name, subdomain: "www")
      print "."
    end
  end

  task :generate_x => :environment do
    categories = ["You Bet"]
    categories.each do |name|
      Category.create!(name: name, subdomain: "x")
      print "."
    end
  end
  
  task :clear => :environment do
    Category.destroy_all
    print "done."
  end
end
