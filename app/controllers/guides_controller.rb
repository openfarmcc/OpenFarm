class GuidesController < ApplicationController
  def new
    @guide = Guide.new
  end
  
  def index
    @guides = Guide.all
  end

  def show
    # TODO => season/dates are dependent on locality.
    @seasons = {
      'Winter' => 'Dec 22 - Mar 21',
      'Spring' => 'Mar 22 - Jun 21',
      'Summer' => 'Jun 22 - Sep 21',
      'Fall'   => 'Sep 22 - Dec 21'
    }
    @months = ['Jan', 'Feb', 'Mar', 'Apr', 'May',
              'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
              'Nov', 'Dec']

    @guide = Guide.find(params[:id])

    @is_guide_page = true

    @stage = Stage.new
  end
  
  def create
    @guide = Guide.new(guides_params)
    if @guide.save
      redirect_to @guide
    else
      render :new
    end
  end
  
  private
  def guides_params
    params.require(:guide).permit(:name, :user)
  end
end