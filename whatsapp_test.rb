require 'httparty'
require 'logger'
require 'json'

# curl -i -X POST \
#   https://graph.facebook.com/v18.0/290080084182795/messages \
#   -H 'Authorization: Bearer EAAPitiH3DWQBO43ZBlapxRKKNSYZCDc9SfWLHHMZB65KkZADgMVvGc270HC9oFGKKXAddqBqlJFvZBRfW2hAON2T9KXsNZCdvpusUeOkVlWya0JDzxprf1wYAuYdVG9gIaUTg565cJJBAd3MrmgdY83h35PWgFTNaPLUCAqBjuDA4ZCFeqfGtIyg9M5bf5fHqd03HRZCf3E8dnr70HgCQryI68LerUy7F2ZC1' \
#   -H 'Content-Type: application/json' \
#   -d '{ "messaging_product": "whatsapp", "to": "5581982028696", "type": "template", "template": { "name": "hello_world", "language": { "code": "en_US" } } }'

TOKEN = "EAAPitiH3DWQBO43ZBlapxRKKNSYZCDc9SfWLHHMZB65KkZADgMVvGc270HC9oFGKKXAddqBqlJFvZBRfW2hAON2T9KXsNZCdvpusUeOkVlWya0JDzxprf1wYAuYdVG9gIaUTg565cJJBAd3MrmgdY83h35PWgFTNaPLUCAqBjuDA4ZCFeqfGtIyg9M5bf5fHqd03HRZCf3E8dnr70HgCQryI68LerUy7F2ZC1"
SENDER_ID = "290080084182795"
BUSINESS_ID = "281794731680750"
RECIPIENT_ID = "5581982028696"
BASE_URL = "https://graph.facebook.com/v18.0/" + SENDER_ID + "/messages"

LOG = Logger.new(STDOUT)

class WhatsappClient
  include HTTParty

  def initialize

    data = {
      "messaging_product": "whatsapp",    
      "recipient_type": "individual",
      "to": RECIPIENT_ID,
      "type": "text",
      "text": {
          "preview_url": false,
          "body": "Ruby é pika"
      }
    }

    response = self.class.post(
      BASE_URL,
      body: (data),
      headers:{
        'Content-type' => 'application/json',
        'Authorization' => "Bearer #{TOKEN}",

      }
    )

    @response_body = JSON.parse(response.body)
    LOG.info "#{@response_body}" if @response_body['error']

    @contacts = @response_body['contacts']
    @messages = @response_body['messages']

  end

  def details

    {
      contacts: @contacts,
      messages: @messages
    }

  end


end

zapzap = WhatsappClient.new

p zapzap.details

