#!/usr/bin/env ruby

require 'sinatra'
require 'json'

get "/api/hosts" do
  (1..20).map do |id|
    {id: id, name: "Host number #{id}"}
  end.to_json
end

get "/api/host/:id" do
  id = params[:id].to_i
  return not_found { "Host with id #{id} does not exist" } if id < 1 || id > 20
  {id: id, name: "Host number #{id}", description: "Description of host #{id}"}.to_json
end

public_folder = settings.public_folder
cache_folder = File.expand_path("../cache", __FILE__)

known_urls = %w{/ /host/:id}
known_urls.each do |url|
  get url do
    PageHandler.new(request, settings.public_folder, cache_folder).content
  end
end

class PageHandler
  def initialize(request, public_folder, cache_folder)
    @request = request
    @public_folder = public_folder
    @cache_folder = cache_folder
  end

  def content
    if internal_crawler?
      render_content_with_phantomjs
    elsif external_crawler?
      render_cached_content
    else
      index_html
    end
  end

  private

  def internal_crawler?
    @request.user_agent =~ /grab-html/
  end

  def external_crawler?
    @request.user_agent =~ /https?/
  end

  def render_content_with_phantomjs
    phantomjs = File.expand_path("../bin/phantomjs", __FILE__)
    crawler_script = File.expand_path("../crawler/script.js", __FILE__)
    `'#{phantomjs}' '#{crawler_script}' '#{@request.url}'`
  end

  def index_html
    File.read(File.join(@public_folder, 'index.html'))
  end

  def render_cached_content
    path = @request.path
    path = "index.html" if path == "/"
    query = @request.query_string
    url = [path, query].reject{|s| s == ""}.join("?")
    File.read(File.join(@cache_folder, url))
  end
end

