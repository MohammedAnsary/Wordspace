# Author: Mayar
# Date: 8.4.2015
# Invitation Controller
class CollaborationInvitationsController < ApplicationController
  

  def index
    @reqinv = CollaborationInvitation.where(User_id: :current_user_id)
  end

  def check_for_approve
    
    @i = params[:i2]
    @user = User.find(@i.User_id)
    @magazne = Magazine.find(@i.Magazine_id)
    @magazine.users << @user
    @record = CollaborationInvitation.find(@i)
    ColloborationInvitation.destroy(@record)
    redirect_to invitations_path
  end

  def check_for_reject
    
    @record = CollaborationInvitation.find(params[:i2])
    ColloborationInvitation.destroy(@record)
    redirect_to invitations_path
  end
end
