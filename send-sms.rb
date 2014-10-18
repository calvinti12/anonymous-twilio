require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

# Credentials
account_sid = "AC5e0e37adaf556c3ef136e9ba71536c74"
auth_token  = "f5ca2a5df3edfbf3c1f81014d11de97b"
client      = Twilio::REST::Client.new account_sid, auth_token
from        = "+17606421123" # Your Twilio number

 
friends = {
"+18582295512" => "Anthony"
}


friends.each do |key, value|
  client.account.messages.create(
    :from => from,
    :to => key,
    :body => "Hey #{value}, Monkey party at 6PM. Bring Bananas!"
  )
  puts "Sent message to #{value}"
end