module GitCookbook
  module Helpers
    # linux packages default to distro offering
    def parsed_package_name
      return new_resource.package_name if new_resource.package_name
      return 'git-core' if node['platform'] == 'ubuntu' && node['platform_version'].to_f < 10.10
      return 'developer/versioning/git' if node['platform'] == 'omnios'
      return 'scmgit' if node['platform'] == 'smartos'
      'git'
    end

    def parsed_package_version
      return new_resource.package_version if new_resource.package_version
    end

    # source
    def parsed_source_url
      return new_resource.source_url if new_resource.source_url
      return "https://nodeload.github.com/git/git/tar.gz/v#{new_resource.source_version}"
    end

    def parsed_source_checksum
      return new_resource.source_checksum if new_resource.source_checksum
      return '0f30984828d573da01d9f8e78210d5f4c56da1697fd6d278bad4cfa4c22ba271' # 1.9.5 tarball
    end

    # windows
    def parsed_windows_display_name
      return new_resource.windows_display_name if new_resource.windows_display_name
      "Git version #{parsed_windows_package_version}"
    end

    def parsed_windows_package_version
      return new_resource.windows_package_version if new_resource.windows_package_version
      '1.9.5-preview20141217'
    end

    def parsed_windows_package_url
      return new_resource.windows_package_url if new_resource.windows_package_url
      "https://github.com/msysgit/msysgit/releases/download/Git-#{parsed_windows_package_version}/Git-#{parsed_windows_package_version}.exe"
    end

    def parsed_windows_package_checksum
      return new_resource.windows_package_checksum if new_resource.windows_package_checksum
      'd7e78da2251a35acd14a932280689c57ff9499a474a448ae86e6c43b882692dd'
    end

  end
end
