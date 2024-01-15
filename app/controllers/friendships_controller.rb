class FriendshipsController < ApplicationController
  def create
    current_user.friendships.build(friend_id: params[:friend])
    current_user.save
    if current_user.save
      flash[:notice] = "User followed"
    else
      flash[:alert] = "There was something wrong"
    end
    redirect_to my_friends_path
  end

  def destroy
    current_user.friendships.where(friend_id: params[:id]).first.destroy
    flash[:notice] = "Friend removed"
    redirect_to my_friends_path
  end
end
