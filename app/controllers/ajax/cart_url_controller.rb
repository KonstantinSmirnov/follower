class Ajax::CartUrlController < ApplicationController
  skip_before_filter :require_login

  def update
    @webpage = Webpage.find_by(id: params[:id], widget_token: params[:token])

    if @webpage != nil
      @webpage.update_attribute(:cart_url, params[:url])
      render json: true
    else
      render json: false
    end
  end
end
