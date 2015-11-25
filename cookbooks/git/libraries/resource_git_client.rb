require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class GitClient < Chef::Resource::LWRPBase
      self.resource_name = :git_client
      actions :install, :remove
      default_action :install

      provides :git_client

      # used by source providers
      attribute :source_checksum, kind_of: String, default: nil
      attribute :source_prefix, kind_of: String, default: '/usr/local'
      attribute :source_url, kind_of: String, default: nil
      attribute :source_use_pcre, kind_of: [TrueClass, FalseClass], default: false
      attribute :source_version, kind_of: String, default: nil

      # used by linux package providers
      attribute :package_name, kind_of: String, default: nil
      attribute :package_version, kind_of: String, default: nil
      attribute :package_action, kind_of: Symbol, default: :install

      # used by OSX package providers
      attribute :osx_dmg_app_name, kind_of: String, default: 'git-1.9.5-intel-universal-snow-leopard'
      attribute :osx_dmg_package_id, kind_of: String, default: 'GitOSX.Installer.git195.git.pkg'
      attribute :osx_dmg_volumes_dir, kind_of: String, default: 'Git 1.9.5 Snow Leopard Intel Universal'
      attribute :osx_dmg_url, kind_of: String, default: 'http://sourceforge.net/projects/git-osx-installer/files/git-1.9.5-intel-universal-snow-leopard.dmg/download'
      attribute :osx_dmg_checksum, kind_of: String, default: '61b8a9fda547725f6f0996c3d39a62ec3334e4c28a458574bc2aea356ebe94a1' # 1.9.5

      # used by Windows providers
      attribute :windows_display_name, kind_of: String, default: nil
      attribute :windows_package_url,  kind_of: String, default: nil
      attribute :windows_package_checksum,  kind_of: String, default: nil
      attribute :windows_package_version,  kind_of: String, default: nil
    end
  end
end
