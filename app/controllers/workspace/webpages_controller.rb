class Workspace::WebpagesController < WorkspaceController
  require 'open-uri'
  require 'nokogiri'

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
        format.js { render 'show_modal_errors' }
      end
    end
  end

  def edit
    @webpage = Webpage.find(params[:id])
  end

  def update
    @webpage = Webpage.find(params[:id])

    respond_to do |format|
      if @webpage.update_attributes(webpage_params)
        format.html { redirect_to edit_workspace_webpage_path(@webpage), notice: 'Successfully updated' }
      else
        format.js { render 'show_errors' }
      end
    end
  end

  def remove_modal
    @webpage = Webpage.find(params[:id])
    respond_to do |format|
      format.js { render 'delete_modal' }
    end
  end

  def destroy
    @webpage = Webpage.find(params[:id])
    webpage_name = @webpage.name
    respond_to do |format|
      if params[:webpage][:name_confirmation] == @webpage.name
        @webpage.destroy
        format.html { redirect_to workspace_dashboard_path, notice: "#{webpage_name} was successfully deleted" }
      else
        @webpage.errors.add(:base, "Entered value does not match with webpage name.")
        @webpage.errors.full_messages.each { |msg| puts msg }
        format.js { render 'show_modal_errors' }
      end
    end
  end

  def confirm_widget_script
    @webpage = Webpage.find(params[:id])

    respond_to do |format|

      url = @webpage.url

      begin
        html = open(URI.parse(url))
        doc = Nokogiri::HTML(html)
        if doc.css('#follower_widget__init_script').any?
          set_webpage_has_script(true)
          format.js { render 'confirm_widget_script' }
        else
          set_webpage_has_script(false)
          format.js { render 'not_confirm_widget_script' }
        end
      rescue
        set_webpage_has_script(false)
        format.js { render 'not_confirm_webpage_url' }
      end
    end
  end

  private

  def webpage_params
    params.require(:webpage).permit(:name, :url)
  end

  def set_webpage_has_script(value)
    case value
    when true
      if !@webpage.has_script?
        @webpage.has_script = true
        @webpage.save
      end
    when false
      if @webpage.has_script?
        @webpage.has_script = false
        @webpage.save
      end
    end

  end

end
