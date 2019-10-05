# frozen_string_literal: true

class Api::V1::ProgressJobController < Api::V1::BaseController
  def show
    obj_type = params[:obj_type]
    id = params[:obj_id]
    object_class =
      case obj_type
      when 'crop'
        Crop
      when 'guide'
        Guide
      when 'stage'
        Stage
      end
    render json: { processing: object_class.find(id).processing_pictures }
  end
end
