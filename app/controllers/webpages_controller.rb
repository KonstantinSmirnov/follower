class WebpagesController < ApplicationController
  def create
    @webpage = Webpage.new(webpage_params)

    if @webpage.save
      flash[:success] = 'You have added new web page'
      redirect_to root_path
    else
      flash[:danger] = 'New web page was not added'
      redirect_to root_path
    end
  end

  private

  def webpage_params
    params.require(:webpage).permit(:url)
  end
end
