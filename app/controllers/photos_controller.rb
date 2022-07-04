class PhotosController < ApplicationController
  before_action :logged_in_user

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
      redirect_to photos_path, notice: "Photo was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def photo_params
    params.require(:photo).permit(:title, :image)
  end
end
