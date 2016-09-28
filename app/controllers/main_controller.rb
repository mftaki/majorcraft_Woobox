class MainController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def index
  end

  def listen
    response.headers['realtimeapi_code'] = params['realtimeapi_code']
    p params['entries']
  end
end
