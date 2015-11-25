default['yum']['epel-source']['repositoryid'] = 'epel-source'

case node['platform']
when 'amazon'
  default['yum']['epel-source']['description'] = 'Extra Packages for Enterprise Linux 6 - $basearch'
  default['yum']['epel-source']['mirrorlist'] = 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  default['yum']['epel-source']['gpgkey'] = 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
else
  case node['platform_version'].to_i
  when 5
    default['yum']['epel-source']['description'] = 'Extra Packages for Enterprise Linux 5 - $basearch - Source'
    default['yum']['epel-source']['mirrorlist'] = 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-source-5&arch=$basearch'
    default['yum']['epel-source']['gpgkey'] = 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL'
  when 6
    default['yum']['epel-source']['description'] = 'Extra Packages for Enterprise Linux 6 - $basearch - Source'
    default['yum']['epel-source']['mirrorlist'] = 'https://mirrors.fedoraproject.org/metalink?repo=epel-source-6&arch=$basearch'
    default['yum']['epel-source']['gpgkey'] = 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  when 7
    default['yum']['epel-source']['description'] = 'Extra Packages for Enterprise Linux 7 - $basearch - Source'
    default['yum']['epel-source']['mirrorlist'] = 'https://mirrors.fedoraproject.org/metalink?repo=epel-source-7&arch=$basearch'
    default['yum']['epel-source']['gpgkey'] = 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7'
  end
end

default['yum']['epel-source']['failovermethod'] = 'priority'
default['yum']['epel-source']['gpgcheck'] = true
default['yum']['epel-source']['enabled'] = false
default['yum']['epel-source']['managed'] = false
