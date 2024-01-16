class UsersController < ApplicationController
  def my_portfolio
    @tracked_stocks = current_user.stocks
    @user = current_user
  end

  def my_friends
    @followed_friends = current_user.friends
  end

  def search
    if params[:friend].present?
      @friends = User.search(params[:friend])
      @friends = current_user.except_current_user(@friends)
    if @friends
      if turbo_frame_request? && turbo_frame_request_id == 'f-res'
        render partial: 'users/friend_result'
      end
    else
      if turbo_frame_request? && turbo_frame_request_id == 'f-res'
        flash.now[:alert] = "Couldn't find #{params[:friend]}"
        render partial: 'users/friend_result'
      end
    end
    else
      if turbo_frame_request? && turbo_frame_request_id == 'f-res'
        flash.now[:alert] = "Please enter a friend to search"
        render partial: 'users/friend_result'
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end
end
