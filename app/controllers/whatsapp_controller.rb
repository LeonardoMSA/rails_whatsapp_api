
class WhatsappController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:webhook_post]
    include HTTParty

    TOKEN = "EAAKjyq3JnT0BO09CZB0du2GZBXn8ZBr04CyTxTP39Ln7BjoPBFqOtZCzfqKY9lUczMZCK6ABZCb9NyqUUpSZCY7NTnU8efMImpFNPHTAbr0CH8ifpOQrvsMBTLpPTVP7KI44DzxM7GDMJdeoJYY1WR5rvdJ8WwJ3kBv5mhnpOTILqK8S8thyExGrH8csXADaM6jHLs8t9BBCC3XBc4oX6QWhv9ZBWdi63llHVwZDZD"
    SENDER_ID = "298264706694807"
    BUSINESS_ID = "281852878343628"
    RECIPIENT_ID = "5581982028696"
    BASE_URL = "https://graph.facebook.com/v18.0/" + SENDER_ID + "/messages"

    def enviar_mensagem_form        
        @messages = Message.all
    end
    
    def enviar_mensagem
        msg = params[:mensagem]

        @messages = Message.all
    
        if msg.present?
          data = {
            "messaging_product": "whatsapp",    
            "recipient_type": "individual",
            "to": RECIPIENT_ID,
            "type": "text",
            "text": {
              "preview_url": false,
              "body": msg
            }
          }
    
          response = HTTParty.post(
            BASE_URL,
            body: data.to_json,
            headers: {
              'Content-Type' => 'application/json',
              'Authorization' => "Bearer #{TOKEN}"
            }
          )
    
          @response_body = JSON.parse(response.body)
          Rails.logger.info @response_body if @response_body['error']
    
          if response.success?
            flash[:success] = "Mensagem enviada com sucesso!"

            @mensagem = Message.new(body: msg)
            @mensagem.save

        else
          flash[:error] = "Erro ao enviar mensagem: #{response.body}"
        end
        else
          flash[:error] = "Por favor, insira uma mensagem antes de enviar."
        end
    
        redirect_to enviar_mensagem_path
    end

    def webhook
      if params['hub.mode'] == 'subscribe' && params['hub.verify_token'] == '12345'
        render plain: params['hub.challenge'] and return
      else
        head :forbidden
      end
    end    

    def webhook_post

      payload = request.body.read
      data = JSON.parse(payload)

      if data['entry'] && data['entry'][0]['changes'][0]['field'] == 'messages'

        data['entry'].each do |entry|
          entry['changes'].each do |change|
            if change['field'] == 'messages'              
              handle_incoming_message(change['value'])
            end
          end
        end
        
      end

      head :no_content

    end

    private

    def handle_incoming_message(message_data)

      @mensagem = Message.new(body: message_data['messages'][0]['text']['body'], sent: false)
      @mensagem.save
      redirect_back(fallback_location: root_path)

    end


end

