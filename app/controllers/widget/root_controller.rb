class Widget::RootController < ApplicationController
  protect_from_forgery except: [:init, :root]

  def init
    respond_to do |format|
      format.html

      format.js { render 'init', content_type: Mime::Type.lookup("text/javascript").to_s }
    end
  end

  def root
    respond_to do |format|
      format.html

      format.js { render 'root', :content_type => 'text/javascript' }
    end
  end
end
