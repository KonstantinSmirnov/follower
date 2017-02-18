class Widget::RootController < ApplicationController
  protect_from_forgery except: [:init, :root]

  def init
    respond_to do |format|
      format.html

      format.js { render 'init', formats: [:js] }
    end
  end

  def root
    respond_to do |format|
      format.html

      format.js { render 'root', formats: [:js] }
    end
  end
end
