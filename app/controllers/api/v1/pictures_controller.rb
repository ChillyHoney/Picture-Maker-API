class Api::V1::PicturesController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_api_user!

  def index
    # signed_id = current_api_user.pictures.last.signed_id
    # url = url_for(current_api_user.pictures.last) if current_api_user.pictures.attached?
  end

  def show
    url = []
    current_api_user.pictures.map do |picture|
      url.push(rails_blob_url(picture)) if current_api_user.pictures.attached?
    end

    render json: url.reverse if current_api_user.pictures.count == url.count
  end

  def create
    current_api_user.pictures.attach(params[:file])
  end

end
