require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class GitService < Chef::Resource::LWRPBase
      self.resource_name = :git_service
      actions :create
      default_action :create

      provides :git_service

      # used by the service xinetd provider
      attribute :service_base_path, kind_of: String, default: '/srv/git'
    end
  end
end
