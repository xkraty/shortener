# The back office: every user and every link, visible only to an admin
# account. Authentication is already handled by ApplicationController; this
# just adds the extra "and you must be an admin" gate on top.
class Admin::BaseController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    head :not_found unless current_user&.admin?
  end
end
