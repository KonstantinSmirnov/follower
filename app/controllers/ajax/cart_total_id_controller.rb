class Ajax::CartTotalIdController < ApplicationController

  def update
    @webpage = Webpage.find_by(id: params[:id], widget_token: params[:token])

    if @webpage != nil
      @webpage.update_attribute(:cart_total_id, params[:cart_total_id])
      render json: true
    else
      render json: false
    end
  end

end
