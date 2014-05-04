class MessagesController < ApplicationController
  before_action :signed_in_user

  def index
    @messages = current_user.messages_received.group(:sender_id).page(params[:page])
    @messages_count = @messages.count
  end

  def show
    @messages
  end

  def create
    @message = current_user.messages_sended.build(message_params)
  end

  def destroy
    @message.destroy
    redirect_to messages_path, flash: { success: "Message deleted!" }
  end

  private
    def message_params
      params.require(:message).permit(:content, :receiver_id)
    end
end