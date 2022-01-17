class Api::V1::PicturesController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_api_user!
  before_action :set_attachment, only: [:destroy]

  def show
    pictures = current_api_user.pictures.map do |p|
      { id: p.id, filename: p.filename, url: rails_blob_url(p) }
    end
    render json: pictures.reverse
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
    params.require(:id)
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def file_params
    params.require(:file)
  end
end