default['yum']['epel-testing-debuginfo']['repositoryid'] = 'epel-testing-debuginfo'

case node['platform']
when 'amazon'
  default['yum']['epel-testing-debuginfo']['description'] = 'Extra Packages for Enterprise Linux 6 - $basearch'
  default['yum']['epel-testing-debuginfo']['mirrorlist'] = 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  default['yum']['epel-testing-debuginfo']['gpgkey'] = 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
else
  case node['platform_version'].to_i
  when 5
    default['yum']['epel-testing-debuginfo']['description'] = 'Extra Packages for Enterprise Linux 5 - Testing - $basearch Debug'
    default['yum']['epel-testing-debuginfo']['mirrorlist'] = 'http://mirrors.fedoraproject.org/mirrorlist?repo=testing-debug-epel5&arch=$basearch'
    default['yum']['epel-testing-debuginfo']['gpgkey'] = 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL'
  when 6
    default['yum']['epel-testing-debuginfo']['description'] = 'Extra Packages for Enterprise Linux 6 - Testing - $basearch Debug'
    default['yum']['epel-testing-debuginfo']['mirrorlist'] = 'https://mirrors.fedoraproject.org/metalink?repo=testing-debug-epel6&arch=$basearch'
    default['yum']['epel-testing-debuginfo']['gpgkey'] = 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  when 7
    default['yum']['epel-testing-debuginfo']['description'] = 'Extra Packages for Enterprise Linux 7 - Testing - $basearch Debug'
    default['yum']['epel-testing-debuginfo']['mirrorlist'] = 'https://mirrors.fedoraproject.org/metalink?repo=testing-debug-epel7&arch=$basearch'
    default['yum']['epel-testing-debuginfo']['gpgkey'] = 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7'
  end
end

default['yum']['epel-testing-debuginfo']['failovermethod'] = 'priority'
default['yum']['epel-testing-debuginfo']['gpgcheck'] = true
default['yum']['epel-testing-debuginfo']['enabled'] = false
default['yum']['epel-testing-debuginfo']['managed'] = false
