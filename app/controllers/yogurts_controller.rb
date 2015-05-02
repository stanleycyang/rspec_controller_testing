class YogurtsController < ApplicationController

  def index
    @yogurts = Yogurt.all
  end

  def show
    @yogurt = Yogurt.find(params[:id])
  end

  def new
    @yogurt = Yogurt.new
  end

  def create
    @yogurt = Yogurt.new(yogurt_params)

    if @yogurt.save
      redirect_to yogurts_path
    else
      render :new
    end
  end

  def edit
    @yogurt = Yogurt.find(params[:id])
  end

  def update
    @yogurt = Yogurt.find(params[:id])

    if @yogurt.update(yogurt_params)
      redirect_to yogurts_path
    else
      render :edit
    end
  end

  def destroy
    @yogurt = Yogurt.find(params[:id])
    @yogurt.destroy
    redirect_to yogurts_path
  end
  private

    def yogurt_params
      params.require(:yogurt).permit(:name, :calories)
    end
end
