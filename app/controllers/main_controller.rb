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
      oj = false
      op = false
      sj = false
      il = false
      tr = false
      cr = false
      bs = false

      myclient = ET_Client.new auth
      p myclient

      entries.each do |entry|
        p entry['email']


        if(entry['offshore-jigging'] == "on")
          p ""
          oj = true
        end

        if(entry['shore-jigging'] == "on")
          p ""
          sj = true
        end

        if(entry['inshore-lure'] == "on")
          p ""
          il = true
        end

        if(entry['offshore-jigging'] == "on")
          p ""
          oj = true
        end

        if(entry['trout'] == "on")
          p ""
          tr = true
        end

        if(entry['crappie'] == "on")
          p ""
          cr = true
        end

        if(entry['bass'] == "on")
          p ""
          bs = true
        end

        bod = entry['Dob-month']+'/'+entry['Dob-day']+'/'+entry['Dob-year']

        t = DateTime
        id = t.now.strftime("%Y%m%d%k%M%S%L")

        dataextensionrow = FuelSDK::DataExtension::Row.new
        dataextensionrow.authStub = myclient
        dataextensionrow.Name = 'WooboxTest'
        dataextensionrow.props = {"SubscriberKey" => id,
                                  "EmailAddress" => entry['email'],
                                  "SignUpTime" => entry['createdate'],
                                  "DOB" => entry['age'],
                                  "Country" => entry['country'],
                                  "State" => entry['state'],
                                  "Offshore-jigging" => oj,
                                  "Offshore-popping" => op,
                                  "Shore-jigging" => sj,
                                  "Inshore-lure" => il,
                                  "Trout" => tr,
                                  "Crappie" => cr,
                                  "Bass" => bs,
                                  "Name" => entry['name'],
                                  "Fishing-frequency" => entry['fishing-frequency'],
                                  "IP_Address" => entry['ipaddress']}
        results = dataextensionrow.post

        p results.results

        # myclient = ET_Client.new auth

        email = entry['email']

    # Send an email with TriggeredSend
#        !p '>>> Send an email with TriggeredSend'
#        sendTrig = FuelSDK::TriggeredSend.new
#        sendTrig.authStub = myclient
#        sendTrig.props = [{"CustomerKey" => "2156", "Subscribers" => {"SubscriberKey"=> email, "EmailAddress"=> email}}]
#        p 'Send Status: ' + sendResponse.status.to_s
#        p 'Code: ' + sendResponse.code.to_s
#        p 'Result Count: ' + sendResponse.results.length.to_s
#        p 'Results: ' + sendResponse.results.inspect
      end
    end
  end

  def auth
      {
        'client' => {
          'id' => "iab0ypob0b6anprz46y10m4x",
          'secret' => "Og2nhtE5N8s9dJil1lQoJHnu"
        }
      }
  end
end
