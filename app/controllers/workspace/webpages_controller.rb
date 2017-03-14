class Workspace::WebpagesController < WorkspaceController

  def show
    @webpage = Webpage.find(params[:id])
  end

  def new
    @webpage = Webpage.new

    respond_to do |format|
      format.js { render 'new'}
    end
  end

  def create
    @webpage = current_user.webpages.new(webpage_params)

    respond_to do |format|
      if @webpage.save
        flash[:success] = 'You have added new web page'
        format.html { redirect_to workspace_webpage_path(@webpage) }
      else
        format.js { render 'create_webpage_error' }
      end
    end
  end

  private

  def webpage_params
    params.require(:webpage).permit(:name, :url)
  end
end
