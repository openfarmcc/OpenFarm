# frozen_string_literal: true
require 'fileutils'

module Api
  # A controller that handles file uploading if AWS is not available.
  class FileUploadController < Api::V1::BaseController
    def upload_file
      if ENV['S3_BUCKET_NAME'].blank?
        file = params[:file]

        rel_path = 'public/temp-uploads/'
        dir_path = Rails.root.join(rel_path)
        extension = File.extname(file.original_filename)

        new_file_name = SecureRandom.uuid.to_s + extension

        file_location = dir_path.join(new_file_name)
        rel_file_location = '/temp-uploads/' + new_file_name
        FileUtils.mkdir_p dir_path

        File.open(dir_path.join(file_location), 'wb') { |f| f.write(file.read) }
        render json: { 'local': true, 'uri': rel_file_location }
      else
        render json: { 'error': 'S3 Bucket Name exists, please use S3' }
      end
    end
  end
end
