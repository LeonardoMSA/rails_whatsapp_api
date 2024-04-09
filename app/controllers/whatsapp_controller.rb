
class WhatsappController < ApplicationController
    include HTTParty

    TOKEN = "EAAPitiH3DWQBO6zF0eMm9YZBVOPn6vGIPpFOD2qOfcgZBMHGZBcilnSZABX8PRjJfjhc30PNPmDsszLQK5RsYvPu91TEF2f9n1DV0ZARV7DUhcRuR6O1jW62ZBcZAcpVgZCQqsn8waZAidItyDpYu2HC0P8ccvifX5SUKZAu0buY4WKZCBVLc8ZALGIERhlZC8Yo6Enoj8ux4RegKBSwQYbchdGFI9CpLazkwfLWTHwZDZD"
    SENDER_ID = "290080084182795"
    BUSINESS_ID = "281794731680750"
    RECIPIENT_ID = "5581982028696"
    BASE_URL = "https://graph.facebook.com/v18.0/" + SENDER_ID + "/messages"

    def enviar_mensagem_form
        # Renderiza o formulário de envio de mensagem
    end
    
    def enviar_mensagem
        msg = params[:mensagem]
    
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

            
        else
            flash[:error] = "Erro ao enviar mensagem: #{response.body}"
        end
        else
          flash[:error] = "Por favor, insira uma mensagem antes de enviar."
        end
    
        redirect_to enviar_mensagem_path
    end
end