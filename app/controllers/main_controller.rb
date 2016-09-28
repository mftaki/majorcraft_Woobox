class MainController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def index
  end

  def listen
    response.headers['realtimeapi_code'] = params['realtimeapi_code']
    values_arr = params['entries'].gsub("\\", "")
    values_arr = params['entries'].gsub("\{", "")
    values_arr = params['entries'].split(":")
    p values_arr
  end
end
