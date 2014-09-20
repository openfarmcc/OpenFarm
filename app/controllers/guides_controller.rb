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

  end

  def new
    @guide = Guide.new
  end

  def edit
    puts Guide.all
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
end
