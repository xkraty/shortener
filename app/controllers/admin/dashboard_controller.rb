class Admin::DashboardController < Admin::BaseController
  def show
    @users = User.left_joins(:links)
                 .select("users.*, COUNT(links.id) AS links_count, COALESCE(SUM(links.clicks), 0) AS clicks_count")
                 .group("users.id")
                 .order(:email_address)

    @links = Link.includes(:user).order(created_at: :desc)
  end
end
