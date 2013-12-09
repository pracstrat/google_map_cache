class DistancesController < ApplicationController
  def calculate
    distance = Distance.where(origin: params[:from], destination: params[:to]).first
    
    unless distance.present?
      distance = Distance.create!(origin: params[:from], destination: params[:to], distance: Distance.distance(params[:from], params[:to]))
    end
    
    respond_to do |format|
      format.json { render json: distance.distance }
    end
  end
end
