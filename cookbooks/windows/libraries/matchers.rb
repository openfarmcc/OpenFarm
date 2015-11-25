if defined?(ChefSpec)
  chefspec_version = Gem.loaded_specs['chefspec'].version
  if chefspec_version < Gem::Version.new('4.1.0')
    define_method = ChefSpec::Runner.method(:define_runner_method)
  else
    define_method = ChefSpec.method(:define_matcher)
  end

  define_method.call :windows_package
  define_method.call :windows_feature
  define_method.call :windows_task
  define_method.call :windows_path
  define_method.call :windows_batch
  define_method.call :windows_pagefile
  define_method.call :windows_zipfile
  define_method.call :windows_shortcut
  define_method.call :windows_auto_run
  define_method.call :windows_printer
  define_method.call :windows_printer_port
  define_method.call :windows_reboot
  #
  # Assert that a +windows_package+ resource exists in the Chef run with the
  # action +:install+. Given a Chef Recipe that installs "Node.js" as a
  # +windows_package+:
  #
  #     windows_package 'Node.js' do
  #       source 'http://nodejs.org/dist/v0.10.26/x64/node-v0.10.26-x64.msi'
  #       action :install
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_package+ resource with ChefSpec.
  #
  # @example Assert that a +windows_package+ was installed
  #   expect(chef_run).to install_windows_package('Node.js')
  #
  # @example Assert that a +windows_package+ was _not_ installed
  #   expect(chef_run).to_not install_windows_package('7-zip')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def install_windows_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_package, :install, resource_name)
  end

  #
  # Assert that a +windows_package+ resource exists in the Chef run with the
  # action +:remove+. Given a Chef Recipe that removes "Node.js" as a
  # +windows_package+:
  #
  #     windows_package 'Node.js' do
  #       action :remove
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_package+ resource with ChefSpec.
  #
  # @example Assert that a +windows_package+ was installed
  #   expect(chef_run).to remove_windows_package('Node.js')
  #
  # @example Assert that a +windows_package+ was _not_ removed
  #   expect(chef_run).to_not remove_windows_package('7-zip')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def remove_windows_package(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_package, :remove, resource_name)
  end

  #
  # Assert that a +windows_feature+ resource exists in the Chef run with the
  # action +:install+. Given a Chef Recipe that installs "NetFX3" as a
  # +windows_feature+:
  #
  #     windows_feature 'NetFX3' do
  #       action :install
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_feature+ resource with ChefSpec.
  #
  # @example Assert that a +windows_feature+ was installed
  #   expect(chef_run).to install_windows_feature('NetFX3')
  #
  # @example Assert that a +windows_feature+ was _not_ installed
  #   expect(chef_run).to_not install_windows_feature('NetFX3')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def install_windows_feature(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_feature, :install, resource_name)
  end

  #
  # Assert that a +windows_feature+ resource exists in the Chef run with the
  # action +:remove+. Given a Chef Recipe that removes "NetFX3" as a
  # +windows_feature+:
  #
  #     windows_feature 'NetFX3' do
  #       action :remove
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_feature+ resource with ChefSpec.
  #
  # @example Assert that a +windows_feature+ was removed
  #   expect(chef_run).to remove_windows_feature('NetFX3')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def remove_windows_feature(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_feature, :remove, resource_name)
  end

  #
  # Assert that a +windows_feature+ resource exists in the Chef run with the
  # action +:delete+. Given a Chef Recipe that deletes "NetFX3" as a
  # +windows_feature+:
  #
  #     windows_feature 'NetFX3' do
  #       action :delete
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_feature+ resource with ChefSpec.
  #
  # @example Assert that a +windows_feature+ was deleted
  #   expect(chef_run).to delete_windows_feature('NetFX3')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def delete_windows_feature(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_feature, :delete, resource_name)
  end

  #
  # Assert that a +windows_task+ resource exists in the Chef run with the
  # action +:create+. Given a Chef Recipe that creates "mytask" as a
  # +windows_task+:
  #
  #     windows_task 'mytask' do
  #       command 'mybatch.bat'
  #       action :create
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_task+ resource with ChefSpec.
  #
  # @example Assert that a +windows_task+ was created
  #   expect(chef_run).to create_windows_task('mytask')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def create_windows_task(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_task, :create, resource_name)
  end

  #
  # Assert that a +windows_task+ resource exists in the Chef run with the
  # action +:delete+. Given a Chef Recipe that deletes "mytask" as a
  # +windows_task+:
  #
  #     windows_task 'mytask' do
  #       action :delete
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_task+ resource with ChefSpec.
  #
  # @example Assert that a +windows_task+ was deleted
  #   expect(chef_run).to delete_windows_task('mytask')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def delete_windows_task(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_task, :delete, resource_name)
  end

  #
  # Assert that a +windows_task+ resource exists in the Chef run with the
  # action +:run+. Given a Chef Recipe that runs "mytask" as a
  # +windows_task+:
  #
  #     windows_task 'mytask' do
  #       action :run
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_task+ resource with ChefSpec.
  #
  # @example Assert that a +windows_task+ was run
  #   expect(chef_run).to run_windows_task('mytask')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def run_windows_task(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_task, :run, resource_name)
  end

  #
  # Assert that a +windows_task+ resource exists in the Chef run with the
  # action +:change+. Given a Chef Recipe that changes "mytask" as a
  # +windows_task+:
  #
  #     windows_task 'mytask' do
  #       action :change
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_task+ resource with ChefSpec.
  #
  # @example Assert that a +windows_task+ was changed
  #   expect(chef_run).to change_windows_task('mytask')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def change_windows_task(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_task, :change, resource_name)
  end

  #
  # Assert that a +windows_path+ resource exists in the Chef run with the
  # action +:add+. Given a Chef Recipe that adds "C:\7-Zip" to the Windows
  # PATH env var
  #
  #     windows_path 'C:\7-Zip' do
  #       action :add
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_path+ resource with ChefSpec.
  #
  # @example Assert that a +windows_path+ was added
  #   expect(chef_run).to add_windows_path('C:\7-Zip')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def add_windows_path(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_path, :add, resource_name)
  end

  #
  # Assert that a +windows_path+ resource exists in the Chef run with the
  # action +:remove+. Given a Chef Recipe that removes "C:\7-Zip" from the
  # Windows PATH env var
  #
  #     windows_path 'C:\7-Zip' do
  #       action :remove
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_path+ resource with ChefSpec.
  #
  # @example Assert that a +windows_path+ was removed
  #   expect(chef_run).to remove_windows_path('C:\7-Zip')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def remove_windows_path(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_path, :remove, resource_name)
  end

  #
  # Assert that a +windows_batch+ resource exists in the Chef run with the
  # action +:run+. Given a Chef Recipe that runs a batch script
  #
  #     windows_batch "unzip_and_move_ruby" do
  #       code <<-EOH
  #       7z.exe x #{Chef::Config[:file_cache_path]}/ruby-1.8.7-p352-i386-mingw32.7z
  #          -oC:\\source -r -y
  #       xcopy C:\\source\\ruby-1.8.7-p352-i386-mingw32 C:\\ruby /e /y
  #       EOH
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_path+ resource with ChefSpec.
  #
  # @example Assert that a +windows_path+ was removed
  #   expect(chef_run).to run_windows_batch('unzip_and_move_ruby')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def run_windows_batch(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_batch, :run, resource_name)
  end

  #
  # Assert that a +windows_pagefile+ resource exists in the Chef run with the
  # action +:set+. Given a Chef Recipe that sets a pagefile
  #
  #     windows_pagefile "pagefile" do
  #       system_managed true
  #       initial_size 1024
  #       maximum_size 4096
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_pagefile+ resource with ChefSpec.
  #
  # @example Assert that a +windows_pagefile+ was set
  #   expect(chef_run).to set_windows_pagefile('pagefile').with(
  #     initial_size: 1024)
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def set_windows_pagefile(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_pagefile, :set, resource_name)
  end

  #
  # Assert that a +windows_zipfile+ resource exists in the Chef run with the
  # action +:unzip+. Given a Chef Recipe that extracts "SysinternalsSuite.zip"
  # to c:/bin
  #
  #     windows_zipfile "c:/bin" do
  #       source "http://download.sysinternals.com/Files/SysinternalsSuite.zip"
  #       action :unzip
  #       not_if {::File.exists?("c:/bin/PsExec.exe")}
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_zipfile+ resource with ChefSpec.
  #
  # @example Assert that a +windows_zipfile+ was unzipped
  #   expect(chef_run).to unzip_windows_zipfile_to('c:/bin')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def unzip_windows_zipfile_to(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_zipfile, :unzip, resource_name)
  end

  #
  # Assert that a +windows_zipfile+ resource exists in the Chef run with the
  # action +:zip+. Given a Chef Recipe that zips "c:/src"
  # to c:/code.zip
  #
  #     windows_zipfile "c:/code.zip" do
  #       source "c:/src"
  #       action :zip
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # +windows_zipfile+ resource with ChefSpec.
  #
  # @example Assert that a +windows_zipfile+ was zipped
  #   expect(chef_run).to zip_windows_zipfile_to('c:/code.zip')
  #
  #
  # @param [String, Regex] resource_name
  #   the name of the resource to match
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def zip_windows_zipfile_to(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_zipfile, :zip, resource_name)
  end

  # All the other less commonly used LWRPs
  def create_windows_shortcut(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_shortcut, :create, resource_name)
  end

  def create_windows_auto_run(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_auto_run, :create, resource_name)
  end

  def remove_windows_auto_run(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_auto_run, :remove, resource_name)
  end

  def create_windows_printer(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_printer, :create, resource_name)
  end

  def delete_windows_printer(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_printer, :delete, resource_name)
  end

  def create_windows_printer_port(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_printer_port, :create, resource_name)
  end

  def delete_windows_printer_port(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_printer_port, :delete, resource_name)
  end

  def request_windows_reboot(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_reboot, :request, resource_name)
  end

  def cancel_windows_reboot(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:windows_reboot, :cancel, resource_name)
  end

end
