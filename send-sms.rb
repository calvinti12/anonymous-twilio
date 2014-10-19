require 'rubygems'
require 'sinatra'
require 'twilio-ruby'
require 'uri'

#Creat new app of type Sinatra
class MyApp < Sinatra::Base
  # Twilio Ruby Gem Credentials
  account_sid = "AC5e0e37adaf556c3ef136e9ba71536c74"
  auth_token  = "f5ca2a5df3edfbf3c1f81014d11de97b"
  client      = Twilio::REST::Client.new account_sid, auth_token
  from        = "+17606421123" # Anthony's Twilio number

  friends = {
      "+18582295512" => "Anthony",
      "+17155737579" => "Alex",
      "+17159372022" => "Nick"
  }

  friendsNames = {
      "Anthony" => "+18582295512",
      "Alex" => "+17155737579",
      "Nick" => "+17159372022"
  }
  
  get '/' do
    # puts params
    fromNumber = params[:From]
    body = params[:Body]
    oldBody = body
    toNumber = body.split(" ")[0]
    body.slice! /^\S+\s+/
    puts toNumber
    puts body

    #Check to see if the number is a 10 digit integer
    puts "==== DIAGNOSING ======"
    puts "toNumber.length #{toNumber.length}"
    puts "toNumber.to_i.to_s == toNumber #{toNumber.to_i.to_s == toNumber}"
    puts "!body.empty? #{!body.empty?}"
    puts "======================"
    if(toNumber.length == 10 && toNumber.to_i.to_s == toNumber && !body.empty?)
      #check to see if the body is just a URL, then send them the image if it is
      if(body =~ URI::regexp)
        #We're working with a URL, let's fetch it.
        client.account.messages.create(
          :from => from,
          :to => toNumber,
          :MediaUrl => body
        )
      else
        #Great, we have a properly formed messaged. Send it
        client.account.messages.create(
          :from => from,
          :to => toNumber,
          :body => body
        )
      end
    else
      #This person doesn't know what they're doing
      puts "========= BEGIN - RESPONSE FROM SOMEONE WHO DOESN'T KNOW WHAT'S GOING ON ==========="
      puts fromNumber
      puts oldBody
      puts "========= END  -  RESPONSE FROM SOMEONE WHO DOESN'T KNOW WHAT'S GOING ON ==========="
    end
  end
end
