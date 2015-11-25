class Chef
  class Provider
    class GitClient
      class Windows < Chef::Provider::GitClient
        include Chef::DSL::IncludeRecipe

        provides :git_client, os: 'windows' if respond_to?(:provides)

        action :install do
          windows_package parsed_windows_display_name do
            action :install
            source parsed_windows_package_url
            checksum parsed_windows_package_checksum
            installer_type :inno
          end

          # Git is installed to Program Files (x86) on 64-bit machines and
          # 'Program Files' on 32-bit machines
          PROGRAM_FILES = ENV['ProgramFiles(x86)'] || ENV['ProgramFiles']
          GIT_PATH = "#{PROGRAM_FILES}\\Git\\Cmd"

          # COOK-3482 - windows_path resource doesn't change the current process
          # environment variables. Therefore, git won't actually be on the PATH
          # until the next chef-client run
          ruby_block 'Add Git Path' do
            block do
              ENV['PATH'] += ";#{GIT_PATH}"
            end
            not_if { ENV['PATH'] =~ /GIT_PATH/ }
            action :nothing
          end

          windows_path GIT_PATH do
            notifies :create, 'ruby_block[Add Git Path]', :immediately
            action :add
          end
        end

        action :delete do
        end
      end
    end
  end
end
