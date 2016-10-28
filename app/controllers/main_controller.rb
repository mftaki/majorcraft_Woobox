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
      c4 = false
      c5 = false

      if(entries[0]['custom_4'] == "Yes")
        c4 = true
      end

      if(entries[0]['custom_5'] == "Yes")
        c5 = true
      end

      myclient = ET_Client.new auth
      p myclient

      dataextensionrow = FuelSDK::DataExtension::Row.new
      dataextensionrow.authStub = myclient
      dataextensionrow.Name = 'WOOBOX_API'
      dataextensionrow.props = {"EmailAddress" => entries[0]['email'],
                                "Signup_Time" => entries[0]['createdate'],
                                "Age" => entries[0]['age'],
                                "City" => entries[0]['city'],
                                "Class" => entries[0]['class'],
                                "Custom4" => c4,
                                "Custom5" => c5,
                                "FName" => entries[0]['first_name'],
                                "LName" => entries[0]['last_name'],
                                "Phone" => entries[0]['phone'],
                                "Occupation" => entries[0]['occupation'],
                                "OtherProfession" => entries[0]['other_profession'],
                                "IP_Address" => entries[0]['ipaddress']}
      results = dataextensionrow.post

      p results.results


      subURL = "https://www.exacttargetapis.com/messaging/v1/messageDefinitionSends/key:2156/send"

      HTTParty.post(subURL, body: {
        "To": {
            "Address": entries[0]['email']
        }
      })


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
