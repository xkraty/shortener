class Admin::LinksController < Admin::BaseController
  def destroy
    Link.find(params[:id]).destroy

    redirect_to admin_root_path, notice: "Link removed."
  end
end
