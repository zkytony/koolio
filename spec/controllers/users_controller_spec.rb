require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe "POST #create" do
    it "saves new user to the db" do
      expect {
        post "/users/", :user => { username: "user1", email: "user1@example.com", password: "valid123" }
      }.to change(User, :count).by(1)
    end

    it "redirects to user homepage after register" do
      post "/users/", :user => { username: "user1", email: "user1@example.com", password: "valid123" }
      expect(response).to redirect_to(assigns(:user))
    end

    it "creates default deck for the new user" do
      expect {
        post "/users/", :user => { username: "user1", email: "user1@example.com", password: "valid123" }
      }.to change(Deck, :count).by(1)
    end

    it "renders root path (log in page) if user failed to be created" do
      expect {
        post "/users/", :user => { username: nil, email: "user1@example.com", password: "valid123" }
      }.to_not change(User, :count)
      expect(response).to render_template("/")
    end
  end
end
