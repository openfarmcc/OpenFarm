# module Requirements
#   class UpdateRequirement < Mutations::Command
#     required do
#       string :id
#       model :user
#       model :requirement
#     end

#     optional do
#       string :name
#       string :required
#     end

#     def validate
#       validate_permissions
#     end

#     def execute
#       set_valid_params
#       requirement
#     end

#     def validate_permissions
#       if requirement.guide.user != user
#         msg = 'You can only update requirements that belong to your guides.'
#         raise OpenfarmErrors::NotAuthorized, msg
#       end
#     end

#     def set_valid_params
#       # TODO: Probably a DRYer way of doing this. Enforce nil: false, perhaps?
#       requirement.name        = name if name.present?
#       requirement.required    = required if required.present?
#       requirement.save
#     end
#   end
# end
