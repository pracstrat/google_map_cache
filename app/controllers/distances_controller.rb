class DistancesController < ApplicationController
  def calculate
    distance = Distance.where(origin: params[:from], destination: params[:to]).first
    
    unless distance.present?
      d = Distance.distance(params[:from], params[:to])
      if d == 0
        render status: :not_found
        return
      end
        
      distance = Distance.create!(origin: params[:from], destination: params[:to], distance: d)
    end
    
    respond_to do |format|
      format.json { render json: distance.distance }
    end
  end
end
