class PhotosController < ApplicationController
  before_action :logged_in_user
  before_action :set_photo, only: [:tweet]

  # GET /photos or /photos.json
  def index
    @photos = Photo.all.order(id: :desc)
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # POST /photos or /photos.json
  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def tweet
    MyTweetApiClient.new.post_tweet(@photo.title, url_for(@photo.image), access_token)
    redirect_to root_path
  end

  private

  def set_photo
    @photo = Photo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
