class Api::V1::UsersController < ApplicationController
  #before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json

  def show
    respond_with User.find(params[:id])
  end
end
