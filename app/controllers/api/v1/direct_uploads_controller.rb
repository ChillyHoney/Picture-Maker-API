class Api::V1::DirectUploadsController < ActiveStorage::DirectUploadsController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  
end