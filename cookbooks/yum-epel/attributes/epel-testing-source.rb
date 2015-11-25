default['yum']['epel-testing-source']['repositoryid'] = 'epel-testing-source'

case node['platform']
when 'amazon'
  default['yum']['epel-testing-source']['description'] = 'Extra Packages for Enterprise Linux 6 - $basearch'
  default['yum']['epel-testing-source']['mirrorlist'] = 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  default['yum']['epel-testing-source']['gpgkey'] = 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
else
  case node['platform_version'].to_i
  when 5
    default['yum']['epel-testing-source']['description'] = 'Extra Packages for Enterprise Linux 5 - Testing - $basearch Source'
    default['yum']['epel-testing-source']['mirrorlist'] = 'http://mirrors.fedoraproject.org/mirrorlist?repo=testing-source-epel5&arch=$basearch'
    default['yum']['epel-testing-source']['gpgkey'] = 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL'
  when 6
    default['yum']['epel-testing-source']['description'] = 'Extra Packages for Enterprise Linux 6 - Testing - $basearch Source'
    default['yum']['epel-testing-source']['mirrorlist'] = 'https://mirrors.fedoraproject.org/metalink?repo=testing-source-epel6&arch=$basearch'
    default['yum']['epel-testing-source']['gpgkey'] = 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  when 7
    default['yum']['epel-testing-source']['description'] = 'Extra Packages for Enterprise Linux 7 - Testing - $basearch Source'
    default['yum']['epel-testing-source']['mirrorlist'] = 'https://mirrors.fedoraproject.org/metalink?repo=testing-source-epel7&arch=$basearch'
    default['yum']['epel-testing-source']['gpgkey'] = 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7'
  end
end

default['yum']['epel-testing-source']['failovermethod'] = 'priority'
default['yum']['epel-testing-source']['gpgcheck'] = true
default['yum']['epel-testing-source']['enabled'] = false
default['yum']['epel-testing-source']['managed'] = false
