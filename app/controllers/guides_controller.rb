class GuidesController < ApplicationController

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
    
  end

  def new
    @guide = Guide.new
  end
  
  def create
    @guide = Guide.new(guides_params)
    if @guide.save
      redirect_to @guide
    else
      render :new
    end
  end

  def edit
    @guide = Guide.find(params[:id])

    if not @guide.user.id == current_user.id
      redirect_to @guide
    end

    @is_editing = true

    @seasons = {
      'Winter' => 'Dec 22 - Mar 21',
      'Spring' => 'Mar 22 - Jun 21',
      'Summer' => 'Jun 22 - Sep 21',
      'Fall'   => 'Sep 22 - Dec 21'
    }
    @months = ['Jan', 'Feb', 'Mar', 'Apr', 'May',
              'Jun', 'Jul', 'Aug', 'Sep', 'Oct',
              'Nov', 'Dec']

    @new_requirement = Requirement.new

    @new_stage = Stage.new

  end

  def update
    puts "******* UPDATING" 
    @guide = Guide.find(params[:id])
    @guide.update_attributes(guides_params)
    if @guide.save
      flash[:notice] = "Guide saved successfully."
      redirect_to(:action => 'show', :id => @guide.id)
    else
      flash[:notice] = "Something went wrong."
      @is_editing = true
      render('show')
    end

  end
  
  private
  def guides_params
    params.require(:guide).permit(:name, :user, :overview)
  end

end