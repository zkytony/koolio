class GrabProfileCards
  # Given a user and type, grab certain number of cards
  # 
  # type can either be "all" or "hot". "all" will result
  # in cards sorted by created time; "hot" will result in
  # cards sorted by the number of likes
  #
  # For "all", the returned object is a hash, with keys
  # being the "time ago in words" from the current time,
  # and values being arrays of card objects.
  #
  # For "hot", the returned object is an array of card
  # objects.
  def self.call(user, type, more, card_ids, subdomain="www") 
    n_cards = 15
    cards = []
    if type == "all"
      cards = get_needed_cards_sort_by_created_at(user, n_cards, more, card_ids, subdomain)
      time_dict = {}
      cards.each do |card|
        time_ago = time_ago_in_words card.created_at
        if not time_dict.member? time_ago
          time_dict[time_ago] = [card] # initialize the array with the card
        else
          time_dict[time_ago] << card
        end
      end
      time_dict
    elsif type == "hot"
      cards = get_needed_cards_sort_by_likes(user, n_cards, more, card_ids, subdomain)
      cards
    else
      nil
    end
  end

  private

    # if more is false or nil, card_ids must be nil;
    # else, card_ids must be an array
    #
    # this method is only for create time sorting
    def self.get_needed_cards_sort_by_created_at(user, n_cards, more, card_ids, subdomain="www")
      if more
        user.cards.where(subdomain: subdomain).where("cards.id NOT IN (?)", card_ids).sort_by(&:created_at).reverse.slice(0, n_cards)
      else
        user.cards.where(subdomain: subdomain).sort_by(&:created_at).reverse.slice(0, n_cards)
      end
    end

    # if more is false or nil, card_ids must be nil;
    # else, card_ids must be an array
    #
    # this method is only for likes number sorting
    def self.get_needed_cards_sort_by_likes(user, n_cards, more, card_ids, subdomain="www")
      if more
        user.cards.where(subdomain: subdomain).where("cards.id NOT IN (?)", card_ids).sort_by(&:likes).reverse.slice(0, n_cards)
      else
        user.cards.where(subdomain: subdomain).sort_by(&:likes).reverse.slice(0, n_cards)
      end
    end

    # Tried to include ActionHelper to use time_ago_in_words, but failed.
    # So writing this method for outputting time difference in words
    def self.time_ago_in_words(time)
      now = Time.now
      diff_m = ((now - time)/60.0).round
      diff_s = (now - time).round

      case diff_m
        when 0..5
          return "just now"
        when 6...45
          return "#{diff_m}m"
        when 45...90
          return "1h"
        when 90...1440
          return "#{(diff_m.to_f / 60.0).round}h"
        when 1440...2520
          return "1d"
        when 2520...43200
          return "#{(diff_m.to_f / 1440.0).round}d"
        when 43200...86400
          return "#{(diff_m.to_f / 10080.0).round}w"
        when 86400...525600
          return "#{(diff_m.to_f / 43200.0).round}m"
        else
          return "#{(diff_m.to_f / 525600.0).round}y"
        end
    end
end
