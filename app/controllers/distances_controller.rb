class DistancesController < ApplicationController
  def calculate
    distance = Distance.where(origin: params[:from], destination: params[:to]).first
    not_found = false
    
    unless distance.present?
      d = Distance.distance(params[:from], params[:to])
      if d == 0
        render nothing: true, status: :not_found
        return
      end
        
      if d == -1
        not_found = true
      else
        distance = Distance.create!(origin: params[:from], destination: params[:to], distance: d)
      end
    end
    
    respond_to do |format|
      format.json {
        if not_found
          render json: -1
        else
          render json: distance.distance
        end
      }
    end
  end
end
