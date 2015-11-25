class Chef
  class Provider
    class GitClient
      class Osx < Chef::Provider::GitClient
        include Chef::DSL::IncludeRecipe

        provides :git_client, os: 'mac_os_x' if respond_to?(:provides)

        action :install do
          dmg_package 'GitOSX-Installer' do
            app new_resource.osx_dmg_app_name
            package_id new_resource.osx_dmg_package_id
            volumes_dir new_resource.osx_dmg_volumes_dir
            source new_resource.osx_dmg_url
            checksum new_resource.osx_dmg_checksum
            type 'pkg'
            action :install
          end
        end

        action :delete do
        end
      end
    end
  end
end
