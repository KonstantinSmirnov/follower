class TestWidgetController < ApplicationController
  skip_before_filter :require_login

  def with_script
  end

  def another_with_script
  end

  def without_script
  end
end
