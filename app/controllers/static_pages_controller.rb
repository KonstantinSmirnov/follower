class StaticPagesController < ApplicationController
  def index
    @webpages = Webpage.all
    @webpage = Webpage.new
  end
end
