class MainController < ApplicationController
  def index
  end

  def listen
    response.headers['realtimeapi_code'] = params['realtimeapi_code']
  end
end
