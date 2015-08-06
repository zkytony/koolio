json.array!(@decks) do |deck|
  json.extract! deck, :id, :title, :description
  json.url deck_url(deck, format: :json)
end
