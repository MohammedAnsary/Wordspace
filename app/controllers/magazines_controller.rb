# Author:Mohammed El-Ansary
# 5.4.2015
# Generated through scaffolding Magazine
class MagazinesController < ApplicationController
  # loading all variables
  load_and_authorize_resource
  # rescue from invalid articles ids
  rescue_from(ActiveRecord::RecordNotFound) do
    fail(CanCan::AccessDenied, 'Article is not found')
  end
  before_action :set_magazine, only: [:show, :edit, :update, :destroy]
  # check if cancel => no updates performed
  before_action :check_for_cancel, only: [:create, :update]

  # GET /magazines
  # GET /magazines.json
  def index
    @magazines = Magazine.all
  end

  # GET /magazines/1
  # GET /magazines/1.json
  def show
    @join = Requestjoiningmagazine
    .where('user_id = ? AND magazine_id = ?', current_user.id, params[:id])
  end

  # GET /magazines/new
  def new
    @magazine = Magazine.new
  end

  # GET /magazines/1/edit
  def edit
  end

  # POST /magazines
  # POST /magazines.json
  def create
    # Author:Mohammed El-Ansary
    # 5.4.2015
    # Adds current user to the magazine's list of contributers
    # and also adds the magazine to the user's list of magazines
    @magazine.users << current_user
    respond_to do |format|
      if @magazine.save
        format.html { redirect_to @magazine, notice: 'Magazine was successfully created.' }
        format.json { render :show, status: :created, location: @magazine }
      else
        format.html { render :new }
        format.json { render json: @magazine.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /magazines/1
  # PATCH/PUT /magazines/1.json
  def update
    respond_to do |format|
      if @magazine.update(magazine_params)
        format.html { redirect_to @magazine, notice: 'Magazine was successfully updated.' }
        format.json { render :show, status: :ok, location: @magazine }
      else
        format.html { render :edit }
        format.json { render json: @magazine.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /magazines/1
  # DELETE /magazines/1.json
  def destroy
    @magazine.destroy
    respond_to do |format|
      format.html { redirect_to magazines_url, notice: 'Magazine was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Cancel an update and return to magazine page
  def check_for_cancel
    return false if params[:commit] != 'Cancel'
    redirect_to @magazine
  end

  # Request joining a magazine
  def join
    joinh = { 'user_id' => current_user.id, 'magazine_id' => params[:id] }
    Requestjoiningmagazine.create(joinh)
    @magazine = Magazine.find(params[:id])
    redirect_to @magazine
  end

  def showrequests
    @request = Requestjoiningmagazine.where('magazine_id = ?', params[:id])
    @users = []
    @request.each do |r|
      @users.push(User.find(r.user_id))
    end
  end

  def approverequest
    @req = Requestjoiningmagazine
    .where("user_id = ? AND magazine_id = ?", params[:user], params[:id])
    @req.destroy_all
    @magazine = Magazine.find(params[:id])
    @user = User.find(params[:user])
    @magazine.users << @user
    redirect_to action: :showrequests
  end

  def rejectrequest
    @req = Requestjoiningmagazine.where(
      "user_id = ? AND magazine_id = ?",
      params[:user],
      params[:id])
    @req.destroy_all
    redirect_to action: :showrequests
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_magazine
    @magazine = Magazine.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def magazine_params
    params.require(:magazine).permit(:name, :decription, :image)
  end
end
