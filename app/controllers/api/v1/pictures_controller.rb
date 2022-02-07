class Api::V1::PicturesController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_api_user!
  # before_action :set_attachment, only: [:destroy]
  # after_action :change_filename, only: [:create]

  def index
    attachment = current_api_user.pictures.find(params[:id]).file
    url = rails_blob_url(attachment)

    render json: {
      id: attachment.id ,
      filename: attachment.filename.base,
      description: current_api_user.pictures.find(params[:id]).description,
      created_at: attachment.created_at.strftime("%Y-%m-%d %H:%M"),
      url: url
    }
  end

  def show
    pictures = current_api_user.pictures.map do |p|
      { id: p.file.id, filename: p.file.filename, type: p.file.content_type}
    end
    render json: pictures.reverse
  end
  # , url: rails_blob_url(p.file) 
  def create
    filename = params.require(:filename)
    # params(:description)
    # (:description => description)
    picture = Picture.new
    picture.file.attach(io: File.open(file_params), filename: filename, content_type: "image/png")
    picture_data = current_api_user.pictures << picture

    json_data = {
      id: picture_data.file.id,
      filename: picture_data.file.filename,
      url: rails_blob_url(file.picture_data)
    }
    render json: json_data, status: :created
  end

  # def create
  #   @new_filename = params[:filename].strip
  #   @description = params[:description].strip

  #   if @new_filename.match(/([a-zA-Z]+)/)
  #     current_api_user.pictures.attach(file_params)
  #     picture_data = current_api_user.pictures.last
  #     json_data = {
  #       id: picture_data.id,
  #       filename: @new_filename,
  #       url: rails_blob_url(picture_data)
  #     }
  #     render json: json_data, status: :created
  #   else
  #     render json: @resource, status: :unprocessable_entity
  #   end
  # end

  def destroy
    current_api_user.pictures.find(params[:id]).purge_later
    current_api_user.pictures.find(params[:id]).delete
  end

  private
  def set_attachment
    params.require(:id)
    ActiveStorage::Attachment.connection
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def file_params
    # io: File.open(file_params), filename: filename, content_type: "image/jpg"
    params.require(:file)
  end

  # def change_filename
  #   picture = current_api_user.pictures.attachments.last

  #   if @new_filename.match(/([a-zA-Z]+)/)
  #     picture.update(
  #       filename: "#{@new_filename}",
  #       description: "#{@description}"
  #     )
  #   end
  # end
end