class StagesController < ApplicationController
  def create
    @stage = Stage.new(stages_params)

    puts "\n\n******** ID: ", @stage

    @stage.guide = Guide.find(params['stage']['guide'])
    
    if @stage.save
      redirect_to(:controller => 'guides', 
        :action => 'show', 
        :id => @stage.guide.id)
    else
      redirect_to(:controller => 'guides', 
        :action => 'show', 
        :id => @stage.guide.id)
    end
  end

  private
    def stages_params
      params.require(:stage).permit(:name, :guide, :days_start, :days_end, :instructions)
    end
end
