class GuidesController < ApplicationController

  def index
    @guides = Guide.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @guides }

    end
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

    @plants_lifetime = 180

    @sow = {
      'start_date' => Date.new(1970,3,1),
      'end_date' => Date.new(1970,5,30)
    }

    @harvest = {
      'start_date' => Date.new(1970, 6, 1),
      'end_date' => Date.new(1970, 8, 30)
    }

    @guide = Guide.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @guide }

    end

  end

  def new
    @guide = Guide.new
  end
  
  def create
    @guide = Guide.new(guides_params)
    if @guide.save
      redirect_to(:action => 'edit', :id => @guide.id)
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
    @guide = Guide.find(params[:id])
    @guide.update_attributes(guides_params)
    if @guide.save
      flash[:notice] = "Guide saved successfully."
      redirect_to(action: 'show', id: @guide.id)
    else
      flash[:notice] = "Something went wrong."
      @is_editing = true
      render('show')
    end

  end
  
  private
  def guides_params
    params.require(:guide).permit(:name, :user, :crop_id, :overview)
  end
end
