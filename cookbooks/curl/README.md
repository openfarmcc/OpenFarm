# Description

Installs/Configures curl

# Requirements

## Platform:

* Centos
* Debian
* Fedora
* Redhat
* Ubuntu

## Cookbooks:

*No dependencies defined*

# Attributes

* `node['curl']['libcurl_packages']` -  Defaults to `%w(curl-devel)`.

# Recipes

* curl::default - Installs/Configures curl
* curl::libcurl - Install/Configure libcurl packages

# License and Maintainer

Maintainer:: John Dewey (<john@dewey.ws>)

License:: Apache 2.0
