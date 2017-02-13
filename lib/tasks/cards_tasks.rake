require 'date'

namespace :card do
  desc "Removes one card with given id. DANGEROUS!"
  task :remove_one, [:id] => :environment do |t, args|
    Card.find(args[:id]).destroy
    puts "Done."
  end

  desc "Removes ALL cards created before the given date. DANGEROUS!"
  task :remove_before_date, [:date] => :environment do |t, args|
    # Get all cards created before the given date. And remove.
    Card.where("created_at < ?", DateTime.parse(args[:date])).destroy_all
    puts "Done."
  end
end
