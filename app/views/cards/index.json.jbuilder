json.array!(@cards) do |card|
  json.extract! card, :id, :deck_id, :user_id, :front_content, :back_content, :flips
  json.url card_url(card, format: :json)
end