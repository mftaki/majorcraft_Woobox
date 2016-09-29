class MainController < ApplicationController
  skip_before_filter  :verify_authenticity_token

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
      
      requestToken = HTTParty.post("https://auth.exacttargetapis.com/v1/requestToken",
        {
        headers: {
          "Content-Type" => "application/json"
        },
        body: {
          "clientId": "7b0dwqmgp5sebmnf5fbvedwr",
          "clientSecret": "dojfvyOTi28i48kyhWOCotv1"
        }.to_json
      })

      access_token = "Bearer " + requestToken.parsed_response["accessToken"]

      new_entry = HTTParty.post("https://www.exacttargetapis.com/hub/v1/dataevents/key:03320FA9-EF5C-4300-BFEC-70D5F0EE618B/rowset",
        {
        headers: {
          "Authorization" => access_token,
          "Content-Type" => "application/json"
        },
        body: {[{
          "keys": {
            "EmailAddress": entries[0]['email']
          },
          "values": {
            "Signup_Time": entries[0]['createdate'],
            "Custom4": entries[0]['custom_4'],
            "FName": entries[0]['first_name'],
            "LName": entries[0]['last_name']
          }
        }]}.to_json
        })
    end
  end
end
