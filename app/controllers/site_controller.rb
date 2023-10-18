class SiteController < ApplicationController
  def show
    respond_to do |format|
      response.header["Navigation-Location"] = url_for
      format.all  { render_resource }
      format.json { render_navigation  }
      format.html { render_resource type: :md, layout: "application" }
    end
  end

  protected
    Node = Data.define(:title, :url, :children)

    def current_resource
      Sitepress.site.get(request.path)
    end

    def render_navigation
      render json: navigation(markdown_resource)
    end

    def markdown_resource
      json_resource = Sitepress.site.get(request.path)
      json_resource.node.resources.format(:md)
    end

    def navigation(resource)
      Node.new(title: resource.node.name, url: resource.request_path, children: resource.children.map { navigation(_1) })
    end

    def render_resource(resource = current_resource, type: nil, **)
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