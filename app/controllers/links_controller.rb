class LinksController < ApplicationController
  before_action :set_link, only: %i[redirect]
  def index
    @recent_links = Link.order(created_at: :desc).limit(5)
  end

  def create
    @link = Link.new(link_params)
    @link.generate_slug

    if @link.save
      render turbo_stream: [
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

    redirect_to @link.original_url, allow_other_host: true
  end

  private

  def link_params
    params.require(:link).permit(:original_url)
  end

  def set_link
    @link = Link.find_by!(slug: params[:slug])
  end
end
