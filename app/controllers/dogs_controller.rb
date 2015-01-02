class DogsController < ApplicationController
  before_action :require_login

  def index
    @dogs = Dog.all
    @dogs.to_json
  end

  def show
    @dog = Dog.find(params[:id].to_i)
  end

  def new
    @dog = Dog.new
  end

  def create
    @dog = Dog.new(dog_params)
    @dog.save
    @owner = Owner.find(session[:current_user])
    @owner.dogs << @dog
    session[:current_dog] = @dog.id
    redirect_to @dog

  end

  def edit
    if params[:id].to_i == session[:current_dog]
      @dog = Dog.find(params[:id].to_i)
    else
     redirect_to '/'
    end
  end

  def update
    @dog = Dog.find(params[:id].to_i)
    if @dog.update(dog_params)
      redirect_to @dog
    else
      render 'edit'
    end
  end

  def destroy
    @dog = Dog.find(params[:id].to_i)
    if @dog.owner_id == session[:current_user]
      @dog.destroy
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def search
    @dogs= Dog.all

    if params[:query][:gender] != ""
      @dogs = @dogs.where(gender: params[:query][:gender])
    end

    if params[:query][:breed] != ""
      @dogs = @dogs.where(breed: params[:query][:breed])
    end

    if params[:query][:size] != ""
      @dogs = @dogs.where(size: params[:query][:size])
    end

    if params[:query][:location] != ""
      @dogs = @dogs.where(location: params[:query][:location])
    end

    render 'index'
  end

  private
  def dog_params
    params.require(:dog).permit(
      :gender,
      :breed,
      :size,
      :birthday,
      :location,
      :tagline,
      :bio,
      :photo_url,
      :name
    )
  end

  def require_login
    unless session[:current_user]
      flash[:login_error] = "You must be logged in to access this section"
      redirect_to root_path # halts request cycle
    end
  end

end
