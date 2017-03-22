class Ajax::TokenValidationController < ApplicationController
  skip_before_filter :require_login

  def index
    @webpage = Webpage.find_by(id: params[:id], widget_token: params[:token])

    render :json => @webpage.try(:id)
  end

end
