class MessagesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:destroy]

  def index
    @messages = current_user.messages_received.group(:sender_name).page(params[:page])
    @messages_count = @messages.count

    @message = current_user.messages_sended.build
  end

  def show
    query = current_user.messages_received
    query = query.where("sender_name = (select sender_name from messages where id = ? )",
                        params[:id])
    @messages = query.page(params[:page])
  end

  def create
    message = current_user.messages_sended.build(message_params)

    if message.save
      flash = { success: "Message has been sended!" }
    else
      error_msg = ""
      message.errors.full_messages.each do |m|
        error_msg << "#{m}; "
      end
      error_msg = "#{error_msg.chop.chop}!"

      flash = { danger: "Message sending failed! Reason: #{error_msg}" }
    end

    render json: flash, status: 200
  end

  def destroy
    @message.destroy
    redirect_to messages_path, flash: { success: "Message has been deleted!" }
  end

  private
    def message_params
      params.require(:message).permit(:content, :receiver_name)
    end
end