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

      myclient = ET_Client.new auth
      p myclient

      entries.each do |entry|
        c4 = false
        c5 = false

        if(entry['own_yamaha_bike'] == "Yes")
          c4 = true
        end

        if(entry[0]['subscribe_newsletter'] == "Yes")
          c5 = true
        end

        

        dataextensionrow = FuelSDK::DataExtension::Row.new
        dataextensionrow.authStub = myclient
        dataextensionrow.Name = 'WOOBOX_API'
        dataextensionrow.props = {"EmailAddress" => entry['email'],
                                  "Signup_Time" => entry['createdate'],
                                  "Age" => entry['age'],
                                  "City" => entry['city'],
                                  "Class" => entry['class'],
                                  "Custom4" => c4,
                                  "Custom5" => c5,
                                  "FName" => entry['first_name'],
                                  "LName" => entry['last_name'],
                                  "Phone" => entry['phone'],
                                  "Occupation" => entry['occupation'],
                                  "OtherProfession" => entry['other_profession'],
                                  "IP_Address" => entry['ipaddress']}
        results = dataextensionrow.post

        p results.results

        myclient = ET_Client.new auth

        email = entry['email']

    # Send an email with TriggeredSend
        p '>>> Send an email with TriggeredSend'
        sendTrig = FuelSDK::TriggeredSend.new
        sendTrig.authStub = myclient
        sendTrig.props = [{"CustomerKey" => "2156", "Subscribers" => {"SubscriberKey"=> email, "EmailAddress"=> email}}]
        sendResponse = sendTrig.send
        p 'Send Status: ' + sendResponse.status.to_s
        p 'Code: ' + sendResponse.code.to_s
        p 'Message: ' + sendResponse.message.to_s
        p 'Result Count: ' + sendResponse.results.length.to_s
        p 'Results: ' + sendResponse.results.inspect
      end
    end
    render status: 200
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
