class Chef
  class Provider
    class GitClient
      class Source < Chef::Provider::GitClient
        include Chef::DSL::IncludeRecipe

        action :install do
          return "#{node['platform']} is not supported by the #{cookbook_name}::#{recipe_name} recipe" if node['platform'] == 'windows'

          include_recipe 'build-essential'
          include_recipe 'yum-epel' if node['platform_family'] == 'rhel' && node['platform_version'].to_i < 6

          # move this to attributes.
          case node['platform_family']
          when 'fedora'
            pkgs = %w(openssl-devel libcurl-devel expat-devel perl-ExtUtils-MakeMaker)
          when 'rhel'
            case node['platform_version'].to_i
            when 5
              pkgs = %w(expat-devel gettext-devel curl-devel openssl-devel zlib-devel)
              pkgs += %w{ pcre-devel } if new_resource.source_use_pcre
            when 6, 7
              pkgs = %w(expat-devel gettext-devel libcurl-devel openssl-devel perl-ExtUtils-MakeMaker zlib-devel)
              pkgs += %w{ pcre-devel } if new_resource.source_use_pcre
            else
              pkgs = %w(expat-devel gettext-devel curl-devel openssl-devel perl-ExtUtils-MakeMaker zlib-devel) if node['platform'] == 'amazon'
              pkgs += %w{ pcre-devel } if new_resource.source_use_pcre
            end
          when 'debian'
            pkgs = %w(libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev)
            pkgs += %w{ libpcre3-dev } if new_resource.source_use_pcre
          end

          pkgs.each do |pkg|
            package pkg
          end

          # reduce line-noise-eyness
          remote_file "#{Chef::Config['file_cache_path']}/git-#{new_resource.source_version}.tar.gz" do
            source parsed_source_url # helpers.rb
            checksum parsed_source_checksum # helpers.rb
            mode '0644'
            not_if "test -f #{Chef::Config['file_cache_path']}/git-#{new_resource.source_version}.tar.gz"
          end

          # reduce line-noise-eyness
          execute "Extracting and Building Git #{new_resource.source_version} from Source" do
            cwd Chef::Config['file_cache_path']
            additional_make_params = ""
            additional_make_params += "USE_LIBPCRE=1" if new_resource.source_use_pcre
            command <<-COMMAND
    (mkdir git-#{new_resource.source_version} && tar -zxf git-#{new_resource.source_version}.tar.gz -C git-#{new_resource.source_version} --strip-components 1)
    (cd git-#{new_resource.source_version} && make prefix=#{new_resource.source_prefix} #{additional_make_params} install)
  COMMAND
            not_if "git --version | grep #{new_resource.source_version}"
            not_if "#{new_resource.source_prefix}/bin/git --version | grep #{new_resource.source_version}"
          end
        end

        action :delete do
        end
      end
    end
  end
end
