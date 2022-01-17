class Api::V1::PicturesController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_api_user!
  before_action :set_attachment, only: [:destroy]

  def show
    url = []
    current_api_user.pictures.map do |picture|
      url.push(rails_blob_url(picture)) if current_api_user.pictures.attached?
    end

    render json: url.reverse if current_api_user.pictures.count == url.count
  end

  def create    
    current_api_user.pictures.attach(file_params)

    json_data = [data = current_api_user.pictures.last, rails_blob_url(data)]
    render json: json_data
  end

  def destroy
    @attachment.purge_later
  end
  
  private
  def set_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def file_params
    params.require(:file)
  end
end