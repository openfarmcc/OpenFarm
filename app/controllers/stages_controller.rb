class StagesController < ApplicationController
  # def create
  #   @stage = Stage.new(stages_params)

  #   if @stage.save
  #     redirect_to(:controller => 'guides',
  #       :action => 'edit',
  #       :id => @stage.guide.id)
  #   else
  #     redirect_to(:controller => 'guides',
  #       :action => 'edit',
  #       :id => @stage.guide.id)
  #   end
  # end

  # private
  #   def stages_params
  #     params.require(:stage).permit(:name, :guide_id, :days_start, :days_end, :instructions)
  #   end
end
