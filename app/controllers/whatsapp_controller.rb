
class WhatsappController < ApplicationController
    include HTTParty

    TOKEN = "EAAKjyq3JnT0BO6A3dB7ZAZBiBdZAKQCGZBck4Gzh87OzqBJmrYov57r6TEOP3bdnucBOUmBEWGf8YAPqDYhuMDyL4tZApBHNiAkKUXEZCYkGcBZCmfbcnZC9U7665HZAwOysMNelp1sqzb6w1KXv0PbWV831gAZCnop3xiPZChWFvo9qEBa4ZBYiKRvTVkuZCctarhTxqBCQZCVEHzfZBEu2DE78DtjbR2W94UcQa0FBgZDZD"
    SENDER_ID = "298264706694807"
    BUSINESS_ID = "281852878343628"
    RECIPIENT_ID = "5581982028696"
    BASE_URL = "https://graph.facebook.com/v18.0/" + SENDER_ID + "/messages"

    def enviar_mensagem_form
        # Renderiza o formulário de envio de mensagem
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
end