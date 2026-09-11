class LinksController < ApplicationController
  # Anyone can follow a short link or see the landing page — only making a link requires an account.
  allow_unauthenticated_access only: %i[index redirect]

  before_action :set_link, only: %i[redirect]

  def index
    return render :landing unless authenticated?

    @recent_links = current_user.links.order(created_at: :desc).limit(5)
  end

  def create
    @link = current_user.links.new(link_params)
    @link.generate_slug

    if @link.save
      render turbo_stream: [
        turbo_stream.remove("links_empty_state"),
        turbo_stream.prepend("links_list_content", partial: "links/link", locals: { link: @link }),
        turbo_stream.update("url_form", partial: "links/form", locals: { link: Link.new }),
        turbo_stream.update("generated_link", partial: "links/generated_link", locals: { link: @link })
      ]
    else
      render turbo_stream: turbo_stream.update("url_form", partial: "links/form", locals: { link: @link })
    end
  end

  def redirect
    @link.increment!(:clicks)

    redirect_to @link.original_url, allow_other_host: true, status: :moved_permanently
  end

  private

  def link_params
    params.require(:link).permit(:original_url)
  end

  def set_link
    @link = Link.find_by!(slug: params[:slug])
  end
end
