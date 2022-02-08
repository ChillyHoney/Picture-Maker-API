class Api::V1::PicturesController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_api_user!
  before_action :id_require, only: [:update, :favourite, :destroy]

  def index
    pictures = current_api_user.pictures.with_attached_file.map do |p|
    {
      id: p.id,
      filename: p.file.filename,
      is_favourite: p.is_favourite,
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
      is_favourite: picture_id.is_favourite,
      created_at: picture_id.file.created_at.strftime("%Y-%m-%d %H:%M"),
      url: rails_blob_url(picture_id.file)
    }
  end

  def create
    picture = Picture.new({:description => params[:description]})
    picture.file.attach(io: File.open(params.require(:file)), filename: params.require(:filename))
    current_api_user.pictures << picture

    json_data = {
      id: picture.id,
      filename: picture.file.filename,
      is_favourite: picture.is_favourite,
      url: rails_blob_url(picture.file),
    }
    render json: json_data, status: :created
  end

  def update
    current_api_user.pictures.find(params[:id]).file.update!(filename: params.require(:filename))
    current_api_user.pictures.find(params[:id]).update!(description: params[:description])
  end

  def favourite
    current_api_user.pictures.find(params[:id]).update!(is_favourite: !current_api_user.pictures.find(params[:id]).is_favourite)
    render json: { is_favourite: current_api_user.pictures.find(params[:id]).is_favourite }
  end

  def destroy
    current_api_user.pictures.find(params[:id]).destroy
  end

  private
  def id_require
    params.require(:id)
  end
end