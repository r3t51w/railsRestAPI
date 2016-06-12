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

    it {shoud respond_with 200}
  end
end
