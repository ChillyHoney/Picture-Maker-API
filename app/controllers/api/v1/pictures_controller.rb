class Api::V1::PicturesController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_api_user!

  def index
    pictures = current_api_user.pictures.map do |p| {
      id: p.id,
      filename: p.file.filename,
      type: p.file.content_type,
      url: rails_blob_url(p.file)
    }
    end
    render json: pictures.reverse

  end

  def show
    picture_id = current_api_user.pictures.find(params[:id])
    render json: {
      id: picture_id.id ,
      filename: picture_id.file.filename.base,
      description: picture_id.description,
      created_at: picture_id.file.created_at.strftime("%Y-%m-%d %H:%M"),
      url: rails_blob_url(picture_id.file)
    }
  end

  def create
    picture = Picture.new({:description => params[:description]})
    picture.file.attach(io: File.open(params.require(:file)), filename: params.require(:filename))
    picture_data = current_api_user.pictures << picture

    json_data = {
      id: current_api_user.pictures.last.id,
      filename: current_api_user.pictures.last.file.filename,
      url: rails_blob_url(current_api_user.pictures.last.file),
    }
    render json: json_data, status: :created
  end

  def destroy
    current_api_user.pictures.find(params[:id]).file.purge
    current_api_user.pictures.find(params[:id]).delete

    render status: :accepted
  end
end