class GiftsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gift, only: [:show, :edit, :update, :destroy, :reserve, :unreserve]
  before_action :authorize_owner, only: [:edit, :update, :destroy]

  def index
    @gifts = current_user.gifts
  end

  def show
  end

  def new
    @gift = Gift.new
  end

  def create
    @gift = current_user.gifts.build(gift_params)
    
    if @gift.save
      redirect_to gifts_path, notice: 'Gift was successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @gift.update(gift_params)
      redirect_to gifts_path, notice: 'Gift was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @gift.destroy
    redirect_to gifts_url, notice: 'Gift was successfully deleted.'
  end

  def reserve
    if @gift.can_be_reserved_by?(current_user)
      @gift.update(reserved_by: current_user)
      redirect_back(fallback_location: root_path, notice: 'Gift reserved successfully.')
    else
      redirect_back(fallback_location: root_path, alert: 'Cannot reserve this gift.')
    end
  end

  def unreserve
    if @gift.reserved_by == current_user
      @gift.update(reserved_by: nil)
      redirect_back(fallback_location: root_path, notice: 'Reservation cancelled.')
    else
      redirect_back(fallback_location: root_path, alert: 'You cannot unreserve this gift.')
    end
  end

  def import
    if request.post?
      file = params[:file]
      
      if file.nil?
        flash.now[:alert] = 'Please select a file to import.'
        render :import
        return
      end

      begin
        spreadsheet = Roo::Spreadsheet.open(file.path)
        header = spreadsheet.row(1)
        
        (2..spreadsheet.last_row).each do |i|
          row = Hash[[header, spreadsheet.row(i)].transpose]
          
          current_user.gifts.create!(
            name: row['name'] || row['Name'],
            price: row['price'] || row['Price'],
            link: row['link'] || row['Link']
          )
        end
        
        redirect_to gifts_path, notice: 'Gifts imported successfully.'
      rescue StandardError => e
        flash.now[:alert] = "Error importing file: #{e.message}"
        render :import
      end
    end
  end

  private

  def set_gift
    @gift = Gift.find(params[:id])
  end

  def authorize_owner
    unless @gift.user == current_user
      redirect_to gifts_path, alert: 'You are not authorized to perform this action.'
    end
  end

  def gift_params
    params.require(:gift).permit(:name, :price, :link, :image)
  end
end
