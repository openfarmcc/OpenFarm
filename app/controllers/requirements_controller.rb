class RequirementsController < ApplicationController
  #   def create
  #     @requirement = Requirement.new(requirement_params)

  #     #TODO: Assign a slug if none has been given.

  #     if @requirement.save
  #       redirect_to(controller: 'guides',
  #         action: 'edit',
  #         id: @requirement.guide.id)
  #     else
  #       redirect_to(controller: 'guides',
  #         action: 'edit',
  #         id: @requirement.guide.id)
  #     end
  #   end

  #   private
  #     def requirement_params
  #       params.require(:requirement).permit(:name,
  #                                           :requirement, :slug, :guide_id)
  #     end
end
