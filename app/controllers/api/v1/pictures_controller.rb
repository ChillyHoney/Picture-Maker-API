class Api::V1::PicturesController < ApplicationController
  include Rails.application.routes.url_helpers
  before_action :authenticate_api_user!
  before_action :set_attachment, only: [:destroy]
  after_action :change_filename, only: [:create]

  def index
    attachment_id = current_api_user.pictures.attachments.find(params[:id])
    url = rails_blob_url(attachment_id)

    render json: {url: url, filename: attachment_id.filename }
  end

  def show
    pictures = current_api_user.pictures.map do |p|
      { id: p.id, filename: p.filename, url: rails_blob_url(p) }
    end
    render json: pictures.reverse
  end

  def create
    @new_filename = params[:filename]
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

  def change_filename
    id = current_api_user.pictures.attachments.last.id
    picture = current_api_user.pictures.attachments.find(id)
    picture.update(filename: "#{@new_filename}#{picture.filename.extension_with_delimiter}")
  end
end