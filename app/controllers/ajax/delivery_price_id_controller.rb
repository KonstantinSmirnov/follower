class Ajax::DeliveryPriceIdController < ApplicationController

  def update
    @webpage = Webpage.find_by(id: params[:id], widget_token: params[:token])

    if @webpage != nil
      @webpage.update_attribute(:delivery_price_id, params[:delivery_price_id])
      render json: true
    else
      render json: false
    end
  end

end
