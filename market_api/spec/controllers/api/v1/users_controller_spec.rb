require 'spec_helper'

describe Api::V1::UsersController do
  before(:each) {request.headers['Accept']= "application/vnd.marketplace.v1"}

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the info about a reporter on hash" do
      user_response = JSON.parse(response.body, symbolize_names: true)
      expect(user_response[:email]).to eql @user.email
    end

    it {should respond_with 200}
  end

  describe "POST #create" do

    context "when successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, {user: @user_attributes}, format: :json
      end
      it "renders json representation for user record just created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql @user_attributes[:email]
      end
      it {should respond_with 201}
    end

    context "When user is not created" do
      before(:each) do
        # no email included in test case
        @invalid_user_attributes = {password: "12345678",
                                    password_confirmation: "12345678"}
        post :create, {user: @invalid_user_attributes}, format: :json
      end
      it "renders errors json" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end
      it "renders JSON errors on why use could not be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "can't be blank"
      end
      it {should respond_with 422}
    end
  end

  describe "PUT/PATCH #update" do
    context "when successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, {id: @user.id, user: {email: "newmail@example.com"}}, format: :json
      end
      it "renders JSON representation for updated user " do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:email]).to eql "newmail@example.com"
      end
      it {should respond_with 200}
    end

    context "when is not created" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, {id: @user.id, user: {email: "invalidmail.com"}}, format: :json
      end
      it "renders errors json" do
        user_response = JSON.parse(response.body,symbolize_names: true)
        expect(user_response).to have_key(:errors)
      end
      it "renders JSON errors on why user cannot be created" do
        user_response = JSON.parse(response.body, symbolize_names: true)
        expect(user_response[:errors][:email]).to include "is invalid"
      end
      it {should respond_with 422}
    end
  end


end
