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

      # auth1 = {'client' => {'id' => "7b0dwqmgp5sebmnf5fbvedwr",'secret' => "dojfvyOTi28i48kyhWOCotv1"}}

      myclient = ET_Client.new auth

      email = entries[0]['email']

      # Send an email with TriggeredSend
          p '>>> Send an email with TriggeredSend'
          sendTrig = FuelSDK::TriggeredSend.new
          sendTrig.authStub = myclient
          sendTrig.props = [{"CustomerKey" => "03320FA9-EF5C-4300-BFEC-70D5F0EE618B", "Subscribers" => {"SubscriberKey"=> email, "EmailAddress"=> email}}]
          sendResponse = sendTrig.send
          p 'Send Status: ' + sendResponse.status.to_s
          p 'Code: ' + sendResponse.code.to_s
          p 'Message: ' + sendResponse.message.to_s
          p 'Result Count: ' + sendResponse.results.length.to_s
          p 'Results: ' + sendResponse.results.inspect



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
