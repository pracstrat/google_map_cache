class DistancesController < ApplicationController
  def calculate
    distance = Distance.where(origin: params[:from], destination: params[:to]).first
    
    unless distance.present?
      d = Distance.distance(params[:from], params[:to])
      case d
      when 0
        render nothing: true, status: :not_found
        return
      when -1
        render json: -1
      else
        distance = Distance.create!(origin: params[:from], destination: params[:to], distance: d)
        render json: distance.distance
      end
    end
  end
end
