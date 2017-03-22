class Ajax::TokenValidationController < ApplicationController
  skip_before_filter :require_login

  def index
    @webpage = Webpage.find_by(id: params[:id], widget_token: params[:token])

    respond_to do |format|
      format.json { render json: @webpage.try(:id) }
    end
  end

end
