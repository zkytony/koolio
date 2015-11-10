require 'rails_helper'

RSpec.describe CardsController, type: :controller do
  include SessionsHelper
  before(:each) do
    request.env["HTTP_REFERER"] = "/"
  end

  describe "POST #create" do
    it "saves new card to the db, and added to default deck" do
      userA = User.new(username: "userA", email: "userA@example.com",
                          password: "123456", password_confirmation: "123456")
      CreateUserAccount.call(userA)
      
      log_in userA  # log in the new user
      expect {
        post :create, :card => { front_content: "<h1>Hi</h1>", back_content: "<h1>Bye</h1>",
          user_id: userA.id }
      }.to change(Card, :count).by(1)
      
      # The card should be added to default deck
      expect(userA.decks.find_by(title: "default").cards.count).to be 1
    end
  end
end
