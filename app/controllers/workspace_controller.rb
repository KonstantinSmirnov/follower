class WorkspaceController < ApplicationController
  before_action :load_init_data

  def load_init_data
    @webpages = current_user.webpages
  end
end
