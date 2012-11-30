#!/usr/bin/env ruby

require 'sinatra'
require 'json'

get "/api/hosts" do
  sleep 1
  (1..20).map do |id|
    {id: id, name: "Host number #{id}"}
  end.to_json
end

get "/api/host/:id" do
  sleep 1
  id = params[:id].to_i
  return not_found { "Host with id #{id} does not exist" } if id < 1 || id > 20
  {id: id, name: "Host number #{id}", description: "Description of host #{id}"}.to_json
end

known_urls = %w{/ /host/:id}
known_urls.each do |url|
  get url do
    send_file File.join(settings.public_folder, 'index.html')
  end
end
