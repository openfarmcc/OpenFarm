class Chef
  class Provider
    class GitClient
      class Package < Chef::Provider::GitClient
        include Chef::DSL::IncludeRecipe

        provides :git_client, os: 'linux' if respond_to?(:provides)

        action :install do
          # FIXME: rhel 5
          include_recipe 'yum-epel' if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 5

          # Software installation
          package "#{new_resource.name} :create #{parsed_package_name}" do
            package_name parsed_package_name
            version parsed_package_version
            action new_resource.package_action
            action :install
          end
        end

        action :delete do
        end
      end
    end
  end
end
