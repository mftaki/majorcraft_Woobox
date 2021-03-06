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
      p "Parsed params['entries']!!!!"
      p "#" * 50
      offshorejigging = false
      offshorepopping = false
      shorejigging = false
      inshorelure = false
      trout = false
      crappie = false
      bass = false

      myclient = ET_Client.new auth
      # p myclient

      entries.each do |entry|
        p "*" * 50
        p "entry['bass']: " + entry['bass']
        p "*" * 50
        p "entry['trout']: " + entry['trout']
        p "*" * 50
        p entry
        p "*" * 50


        if(entry['offshore-jigging'] == "on")
          p "offshore-jigging true"
          offshorejigging = true
        end

        if(entry['shore-jigging'] == "on")
          p "shore-jigging true"
          shorejigging = true
        end

        if(entry['inshore-lure'] == "on")
          p "inshore-lure true"
          inshorelure = true
        end

        if(entry['offshore-popping'] == "on")
          p "offshore-popping true"
          offshorepopping = true
        end

        if(entry['trout'] == "on")
          p "trout true"
          trout = true
        end

        if(entry['crappie'] == "on")
          p "crappie true"
          crappie = true
        end

        if(entry['bass'] == "on")
          p "bass true"
          bass = true
        end

        t = DateTime
        id = 'W' + t.now.strftime("%5N%M%u%H%j")

        dataextensionrow = FuelSDK::DataExtension::Row.new
        dataextensionrow.authStub = myclient
        dataextensionrow.Name = 'Woobox_Subscribers'
        dataextensionrow.props = {"EmailAddress" => entry['email'],
                                  "SubscriberKey" => id,
                                  "SignUpTime" => entry['createdate'],
                                  "Country" => entry['country'],
                                  "State" => entry['state'],
                                  "Offshore-jigging" => offshorejigging,
                                  "Offshore-popping" => offshorepopping,
                                  "Shore-jigging" => shorejigging,
                                  "Inshore-lure" => inshorelure,
                                  "Trout" => trout,
                                  "Crappie" => crappie,
                                  "Bass" => bass,
                                  "Name" => entry['name'],
                                  "DOB" => entry['dob-month'].to_s + '/' + entry['dob-day'].to_s + '/' + entry['dob-year'].to_s,
                                  "Fishing-frequency" => entry['fishing-frequency'],
                                  "IP_Address" => entry['ipaddress']}

        # p "New Row: " + dataextensionrow.props.to_s
        results = dataextensionrow.post
        p "=" * 50
        p "Results: " + results.results.to_s
        p "=" * 50

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
