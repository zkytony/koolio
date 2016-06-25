namespace :deck do
  task :load_tags_names => :environment do
    Deck.find_each(batch_size: 5000) do |deck|
      tags_names = deck.tags_by_name
      deck.tags_names = tags_names
      deck.save!
      print "."
    end
    puts "Success"
  end

  task :set_fav => :environment do
    Deck.find_each(batch_size: 5000) do |deck|
      deck.favorites_count = deck.favoring_users.count
      deck.save!
      print "."
    end
    puts "Success"
  end
end
