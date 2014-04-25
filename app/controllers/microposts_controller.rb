class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:destroy]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    
    if @micropost.content[0] == "@"
      in_reply_to_name = @micropost.content.split(":")[0].delete("@")
      in_reply_to_user = User.find_by(name: in_reply_to_name)

      if in_reply_to_user
        @micropost.in_reply_to = in_reply_to_user.id
      end
    end

    if @micropost.save
      redirect_to root_path, flash: { success: "Micropost created!" }
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_path, flash: { success: "Micropost deleted!" }
  end

  private
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    # Before filters

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_path if @micropost.nil?
    end
end