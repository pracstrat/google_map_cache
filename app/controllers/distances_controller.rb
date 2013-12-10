class DistancesController < ApplicationController
  def calculate
    distance = Distance.where(origin: params[:from], destination: params[:to]).first
    json = nil
    
    if distance.present?
      json = { "status" => "OK", "distance" => distance.distance }
    else
      json = Distance.distance(params[:from], params[:to])
      Distance.create!(origin: params[:from], destination: params[:to], distance: json["distance"]) if json["status"] == "OK"
    end
    
    respond_to do |format|
      format.json { render json: json }
    end
  end
end
