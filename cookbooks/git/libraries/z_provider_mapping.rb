# provider mappings for Chef 11

#########
# client
#########
Chef::Platform.set platform: :amazon, resource: :git_client, provider: Chef::Provider::GitClient::Package
Chef::Platform.set platform: :centos, resource: :git_client, provider: Chef::Provider::GitClient::Package
Chef::Platform.set platform: :debian, resource: :git_client, provider: Chef::Provider::GitClient::Package
Chef::Platform.set platform: :fedora, resource: :git_client, provider: Chef::Provider::GitClient::Package
Chef::Platform.set platform: :mac_os_x, resource: :git_client, provider: Chef::Provider::GitClient::Osx
Chef::Platform.set platform: :redhat, resource: :git_client, provider: Chef::Provider::GitClient::Package
Chef::Platform.set platform: :scientific, resource: :git_client, provider: Chef::Provider::GitClient::Package
Chef::Platform.set platform: :smartos, resource: :git_client, provider: Chef::Provider::GitClient::Package
Chef::Platform.set platform: :solaris2, resource: :git_client, provider: Chef::Provider::GitClient::Package
Chef::Platform.set platform: :suse, resource: :git_client, provider: Chef::Provider::GitClient::Package
Chef::Platform.set platform: :ubuntu, resource: :git_client, provider: Chef::Provider::GitClient::Package
