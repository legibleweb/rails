class SiteController < ApplicationController
  def show
    resource = Sitepress.site.get(request.path)

    respond_to do |format|
      format.all { render_resource resource }
      format.html { render_resource resource, type: :md, layout: "application" }
    end
  end

  protected

  def render_resource(resource, type: nil, **)
    type ||= resource.handler unless resource.handler == Sitepress::Node::DEFAULT_FORMAT

    if resource.renderable?
      render inline: resource.body, type: type, **
    else
      send_binary_resource resource
    end
  end

  def send_binary_resource(resource)
    send_file resource.asset.path,
      disposition: :inline,
      type: resource.mime_type.to_s
  end
end