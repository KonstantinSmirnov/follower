class Ajax::ItemSkuIdController < ApplicationController

  def update
    @webpage = Webpage.find_by(id: params[:id], widget_token: params[:token])

    if @webpage != nil
      @webpage.update_attribute(:item_sku_id, params[:item_sku_id])
      render json: true
    else
      render json: false
    end
  end

end
