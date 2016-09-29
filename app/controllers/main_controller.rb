class MainController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  require 'fuelsdk'

  def index
  end

  def listen

    response.headers['realtimeapi_code'] = params['realtimeapi_code']
    # values_arr = params['entries'].gsub("\\", "")
    # values_arr = params['entries'].gsub("\{", "")
    # values_arr = params['entries'].split(":")
    # p values_arr
    if(params['entries'] != nil)
      entries = JSON.parse(params['entries'])
      p entries
      
      # requestToken = HTTParty.post("https://auth.exacttargetapis.com/v1/requestToken",
      #   {
      #   headers: {
      #     "Content-Type" => "application/json"
      #   },
      #   body: {
      #     "clientId": "7b0dwqmgp5sebmnf5fbvedwr",
      #     "clientSecret": "dojfvyOTi28i48kyhWOCotv1"
      #   }.to_json
      # })

      # access_token = "Bearer " + requestToken.parsed_response["accessToken"]

      # new_entry = HTTParty.post("https://www.exacttargetapis.com/hub/v1/dataevents/key:03320FA9-EF5C-4300-BFEC-70D5F0EE618B/rowset",
      #   {
      #   headers: {
      #     "Authorization" => access_token,
      #     "Content-Type" => "application/json"
      #   },
      #   body: {[{
      #     "keys": {
      #       "EmailAddress": entries[0]['email']
      #     },
      #     "values": {
      #       "Signup_Time": entries[0]['createdate'],
      #       "Custom4": entries[0]['custom_4'],
      #       "FName": entries[0]['first_name'],
      #       "LName": entries[0]['last_name']
      #     }
      #   }]}.to_json
      #   })


      # myClient = FuelSDK::Client.new {'client':{ 'id' => "7b0dwqmgp5sebmnf5fbvedwr", 'secret' => "dojfvyOTi28i48kyhWOCotv1" }}
      # dataextensionrow = FuelSDK::DataExtension::Row.new
      # dataextensionrow.authStub = myClient
      # dataextensionrow.Name = 'ExampleDEName'
      # dataextensionrow.props = {"EmailAddress" => entries[0]['email'], "Signup_Time" => entries[0]['createdate']}
      # results = dataextensionrow.post
      # p results

      myclient = ET_Client.new auth
      p myclient

      dataextensionrow = FuelSDK::DataExtension::Row.new
      dataextensionrow.authStub = myclient
      dataextensionrow.Name = 'WOOBOX_API'
      dataextensionrow.props = {"EmailAddress" => entries[0]['email'], "Signup_Time" => entries[0]['createdate']}
      results = dataextensionrow.post

      p results
    end
  end

  def auth
      {
        'client' => {
          'id' => "7b0dwqmgp5sebmnf5fbvedwr",
          'secret' => "dojfvyOTi28i48kyhWOCotv1"
        }
      }
    end
end
