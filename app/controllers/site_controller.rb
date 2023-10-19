class SiteController < ApplicationController
  around_action :ensure_site_reload

  def show
    respond_to do |format|
      response.header["Navigation-Location"] = url_for
      format.all  { render_resource content_type: current_resource.mime_type }
      format.html { render_resource type: :md, layout: "application" }
      format.json { render_navigation  }
    end
  end

  protected
    Node = Data.define(:title, :url, :children)

    def current_resource
      @current_resource ||= site.get(request.path)
    end

    def render_navigation
      render json: navigation(markdown_resource)
    end

    def markdown_resource
      json_resource = site.get(request.path)
      json_resource.node.resources.format(:md)
    end

    def navigation(resource)
      Node.new(title: resource.data.fetch("title", resource.node.name), url: resource.request_path, children: resource.children.map { navigation(_1) })
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

    # When in development mode, the site is reloaded and rebuilt between each request so
    # that users can see changes to content and site structure. These rebuilds are unnecessary and
    # slow per-request in a production environment, so they should not be reloaded.
    def ensure_site_reload
      yield
    ensure
      reload_site
    end

    # Drops the website cache so that it's rebuilt when called again.
    def reload_site
      site.reload! if reload_site?
    end

    # Looks at the configuration to see if the site should be reloaded between requests.
    def reload_site?
      !Sitepress.configuration.cache_resources
    end

    def site
      Sitepress.site
    end
end