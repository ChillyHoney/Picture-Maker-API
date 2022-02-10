class Api::V1::PicturesController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_api_user!
  before_action :find_picture, only: [:update, :favourite, :destroy, :show]

  def index
    pictures = current_api_user.pictures.with_attached_file.map do |p|
    {
      id: p.id,
      filename: p.filename,
      is_favourite: p.is_favourite,
      type: p.file.content_type,
      url: rails_blob_url(p.file)
    }
    end
    render json: pictures.reverse
  end

  def show
    render json: {
      id: @picture.id ,
      filename: @picture.filename,
      description: @picture.description,
      is_favourite: @picture.is_favourite,
      created_at: @picture.file.created_at.strftime("%Y-%m-%d %H:%M"),
      url: rails_blob_url(@picture.file)
    }
  end

  def create
    picture = Picture.new(
      {
        :description => params[:description],
        :is_favourite => params[:is_favourite],
        :filename => params.require(:filename)
      })
    picture.file.attach(params.require(:file))
    current_api_user.pictures << picture

    json_data = {
      id: picture.id,
      filename: picture.filename,
      is_favourite: picture.is_favourite,
      url: rails_blob_url(picture.file),
    }
    render json: json_data, status: :created
  end

  def update
    params.require(:filename)
    @picture.update(params.require(:picture).permit(:is_favourite, :filename, :description))
  end

  def destroy
    @picture.destroy
  end

  private
  def find_picture
    params.require(:id)
    @picture = current_api_user.pictures.find(params[:id])
  end
end