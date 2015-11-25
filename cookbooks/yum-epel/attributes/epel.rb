default['yum']['epel']['repositoryid'] = 'epel'

case node['platform']
when 'amazon'
  default['yum']['epel']['description'] = 'Extra Packages for Enterprise Linux 6 - $basearch'
  default['yum']['epel']['mirrorlist'] = 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  default['yum']['epel']['gpgkey'] = 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
else
  case node['platform_version'].to_i
  when 5
    default['yum']['epel']['description'] = 'Extra Packages for Enterprise Linux 5 - $basearch'
    default['yum']['epel']['mirrorlist'] = 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-5&arch=$basearch'
    default['yum']['epel']['gpgkey'] = 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL'
  when 6
    default['yum']['epel']['description'] = 'Extra Packages for Enterprise Linux 6 - $basearch'
    default['yum']['epel']['mirrorlist'] = 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch'
    default['yum']['epel']['gpgkey'] = 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  when 7
    default['yum']['epel']['description'] = 'Extra Packages for Enterprise Linux 7 - $basearch'
    default['yum']['epel']['mirrorlist'] = 'https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch'
    default['yum']['epel']['gpgkey'] = 'https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7'
  end
end

default['yum']['epel']['failovermethod'] = 'priority'
default['yum']['epel']['gpgcheck'] = true
default['yum']['epel']['enabled'] = true
default['yum']['epel']['managed'] = true
