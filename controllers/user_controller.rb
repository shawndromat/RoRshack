require_relative '../models/user.rb'

class UserController < ControllerBase
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params["user"])
    if @user.save
      redirect_to user_url(@user.id)
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  private
  def user_params
    params.require("user").permit("fname", "lname")
  end
end