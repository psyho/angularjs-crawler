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

known_urls = %w{/ /host/:id}
known_urls.each do |url|
  get url do
    if crawler?(request)
      render_content_with_phantomjs(request.url)
    else
      index_html
    end
  end
end

def crawler?(request)
  request.user_agent =~ /grab-html/
end

def render_content_with_phantomjs(url)
  crawler_script = File.expand_path("../crawler/script.js", __FILE__)
  `phantomjs '#{crawler_script}' '#{url}'`
end

def index_html
  send_file File.join(settings.public_folder, 'index.html')
end
