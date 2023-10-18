class SiteController < ApplicationController
  def show
    resource = Sitepress.site.get(request.path)

    respond_to do |format|
      format.html { render_resource resource, type: :md, layout: "application" }
      format.all { render_resource resource, layout: "application" }
    end
  end

  protected

  def render_resource(resource, type: nil, **)
    type ||= resource.handler unless resource.handler == :md

    if resource.renderable?
      render inline: resource.body, type: type, **
    else
      send_binary_resource resource
    end
  end
end