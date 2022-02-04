class Api::V1::PicturesController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_api_user!
  before_action :set_attachment, only: [:destroy]
  after_action :change_filename, only: [:create]

  def index
    attachment_id = current_api_user.pictures.attachments.find(params[:id])
    url = rails_blob_url(attachment_id)

    render json: {id: attachment_id.id ,
                filename: attachment_id.filename.base,
                description: attachment_id.description,
                created_at: attachment_id.created_at.strftime("%Y-%m-%d %H:%M"),
                url: url}
  end

  def show
    pictures = current_api_user.pictures.map do |p|
      { id: p.id, filename: p.filename, type: p.content_type, url: rails_blob_url(p) }
    end
    render json: pictures.reverse
  end

  def create
    @new_filename = params[:filename].strip
    @description = params[:description].strip

    if @new_filename.match(/([a-zA-Z]+)/) || @new_filename != ""
      current_api_user.pictures.attach(file_params)
      picture_data = current_api_user.pictures.last
      json_data = {id: picture_data.id,
                  filename: @new_filename,
                  url: rails_blob_url(picture_data)}
      render json: json_data, status: :created
    else
      render json: @resource, status: :unprocessable_entity
    end
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

  def change_filename
    picture = current_api_user.pictures.attachments.last

    if @new_filename.match(/([a-zA-Z]+)/) || @new_filename != ""
      picture.update(filename: "#{@new_filename}",
                    description: "#{@description}")
    end
  end

end