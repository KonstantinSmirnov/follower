class Widget::RootController < ApplicationController
  protect_from_forgery except: [:init, :root]

  def init
    render 'init'
  end

  def root
    respond_to do |format|
      format.html

      format.js { render 'root' }
    end
  end
end
