class MessagesController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:destroy]

  def index
    query = current_user.messages_received.group(:sender_name).except(:order)

    @messages_count = {}
    query.select("sender_name, count(sender_name) as message_count").each do |m|
      @messages_count[m.sender_name] = m.message_count
    end

    query = query.select("max(created_at) as max_created_at")
    created_at_arr = query.map(&:max_created_at)
    query = current_user.messages_received.where(created_at: created_at_arr)
    @messages =  query.page(params[:page])

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