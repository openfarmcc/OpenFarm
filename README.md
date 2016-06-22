[![Coverage Status](https://img.shields.io/coveralls/openfarmcc/OpenFarm.svg)](https://coveralls.io/r/openfarmcc/OpenFarm)
[![Code Climate](https://codeclimate.com/github/openfarmcc/OpenFarm/badges/gpa.svg)](https://codeclimate.com/github/FarmBot/OpenFarm)
[![Issue Stats](http://issuestats.com/github/openfarmcc/openfarm/badge/pr)](http://issuestats.com/github/openfarmcc/openfarm)
[![Issue Stats](http://issuestats.com/github/openfarmcc/openfarm/badge/issue)](http://issuestats.com/github/openfarmcc/openfarm)
[![OpenCollective](https://opencollective.com/openfarm/backers/badge.svg)](#backers) 
[![OpenCollective](https://opencollective.com/openfarm/sponsors/badge.svg)](#sponsors)
[![OpenFarm Gitten](http://gittens.r15.railsrumble.com//badge/openfarmcc/OpenFarm)](http://gittens.r15.railsrumble.com/gitten/openfarmcc/OpenFarm)

OpenFarm
========

[OpenFarm](http://openfarm.cc) is a free and open database and web application for farming and gardening knowledge. One might think of it as the Wikipedia or Freebase for growing plants, though it functions more like a cooking recipes site. The main content are Growing Guides: creative, crowd-sourced, single-author, structured documents that include all of the necessary information for a person or machine to grow a plant, i.e.: seed spacing and depth, watering regimen, recommended soil composition and companion plants, sun/shade requirements, etc.

Other use cases: a mobile app for home gardeners, Google providing &ldquo;One Box&rdquo; answers to search queries such as &ldquo;How do I grow tomatoes?&rdquo;, smart garden sensors, automated farming machines.

### Core Contributor Group

If you have any quick questions, ask them on [IRC on Freenode #openfarmcc](https://webchat.freenode.net/?channels=openfarmcc). If the room looks empty it's because our core team uses Slack, we have a bot piping messages back and forth - read on if you want to join that!

Sign up to [our Slack room](http://slack.openfarm.cc/)! We strongly recommend joining this group if you want to get involved and meet the other contributors. 

### Community Discussion Group

To discuss features, feature requests, and ideas, and to interface with our users at large (and contributors not on GitHub), please check out our public [discussion forum](https://www.loomio.org/g/yWm14fG6/openfarm-community-development-group).

## Development

### Getting Started (The Easy Way)

You should use Vagrant to get the OpenFarm system running on your computer. It will avoid having to install the things listed in The Hard Way below. 

1. Install [Vagrant](https://www.vagrantup.com/docs/installation/).
2. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads). 
3. Open your terminal.
4. `$ git clone https://github.com/openfarmcc/OpenFarm.git` - this tells your computer to fetch the data stored in this repository using git.
5. `$ cd OpenFarm` - change to the OpenFarm directory
6. `$ vagrant up` This will take a long time. We're downloading a whole bunch of stuff. Go make yourself a pot of coffee, or brew some tea. If something goes wrong at this point, reach out to Simon directly at [slack.openfarm.cc](http://slack.openfarm.cc/). Once Vagrant is set up on your system, you'll need to tell the server to start running. To do this:
8. `$ vagrant ssh` - this makes you access the new virtual server we just created to run OpenFarm on.
9. `cd /vagrant` - the `vagrant` directory is mirrored in your own computer. If you add a file there, you'll see it appear here. 
10. `rails s` - actually run the Rails server!
11. you should now be able to access OpenFarm on your local system at http://localhost:3000. If all went well, you will have a seeded database and can use the account `admin@admin.com` with password `admin123`. 

The above is still being patched, so please reach out to us if something went wrong!

### Getting Started (The Hard Way)

You will need to install [Ruby](http://www.ruby-lang.org/en/), [Rails](http://rubyonrails.org/), [ElasticSearch](http://www.elasticsearch.org/), and [Mongodb](http://docs.mongodb.org/manual/installation/) before you can get an OpenFarm server up and running on your local machine. Once you have these prerequisites to get started with a local copy of the project, run:

```bash
$ git clone https://github.com/openfarmcc/OpenFarm.git
$ cd OpenFarm
$ bundle install
$ rake db:setup
$ echo "ENV['SECRET_KEY_BASE'] = '$(rake secret)'" >> config/app_environment_variables.rb
$ rails s
```

Then, visit [http://127.0.0.1:3000/](http://127.0.0.1:3000/) in your browser to see the OpenFarm web application running on your local machine. If all went well, you will have a seeded database and can use the account `admin@admin.com` with password `admin123`.

Remember that `/vagrant` folder in the Vagrant VM is largely for convenience, and working in it can cause unexpected behavior with other tools - you should do your work in your own non-vagrant environment. Use the environment you're most familiar with to program, and Vagrant will do the rest.

**If you had any problems** installing bundles getting up and running etc see the [Common Issues Page](https://github.com/openfarmcc/OpenFarm/wiki/Common-Issues).

#### How to Contribute

Help us [translate the website](https://www.transifex.com/projects/p/openfarm/).

For code, have a look at our [contribution guidelines](https://github.com/openfarmcc/OpenFarm/blob/master/CONTRIBUTING.md).

Want to see the big picture? We have a [project roadmap](https://docs.google.com/spreadsheets/d/13_VQDOm8HpM49Ql3HyNfL9ut5JlqbLEDA9yEk5OqgqU/edit?usp=sharing) for that!

### FAQ

Have a look at the [FAQ](http://openfarm.cc/pages/faq) for some frequently asked questions about contributing (Angular, Issue Trackers, IRC Channels).

### User Flow

![User Flow Diagram] (http://i.imgur.com/YowIq1N.jpg)

![Information Architecture Diagram] (http://i.imgur.com/qZzF4OZ.jpg)

### Mockups

To view the most recent mockups, click [here](https://drive.google.com/open?id=0B-wExYzQcnp3cVZvZ3JXb3FDZTg&authuser=0).

### Contributors

We encourage everyone to contribute! From newbies, to pros, to people who don&#8217;t write software, to those with just a few ideas to share &mdash; we greatly appreciate everyone&#8217;s input and are happy to help you help us. We strive for diversity on our team and are dedicated to making a safe space and community for everyone. To help us ensure this, We have created and adopted a [Code of Conduct](https://openfarm.cc/pages/code_of_conduct?locale=en).

Here are our [current contributors](https://github.com/openfarmcc/OpenFarm/graphs/contributors) here on GitHub. But that's just people who contribute code. There's a whole host of people who contributed financially, and people contribute guides on the actual website too!

### Backers

Support us with a monthly donation and help us continue our activities. [[Become a backer](https://opencollective.com/openfarm#backer)]

<a href="https://opencollective.com/openfarm/backer/0/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/0/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/1/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/1/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/2/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/2/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/3/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/3/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/4/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/4/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/5/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/5/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/6/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/6/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/7/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/7/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/8/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/8/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/9/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/9/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/10/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/10/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/11/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/11/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/12/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/12/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/13/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/13/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/14/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/14/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/15/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/15/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/16/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/16/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/17/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/17/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/18/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/18/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/19/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/19/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/20/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/20/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/21/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/21/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/22/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/22/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/23/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/23/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/24/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/24/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/25/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/25/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/26/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/26/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/27/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/27/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/28/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/28/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/backer/29/website" target="_blank"><img src="https://opencollective.com/openfarm/backer/29/avatar.svg"></a>


### Sponsors

Become a sponsor and get your logo on our README on Github with a link to your site. [[Become a sponsor](https://opencollective.com/openfarm#sponsor)]

<a href="https://opencollective.com/openfarm/sponsor/0/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/0/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/1/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/1/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/2/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/2/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/3/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/3/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/4/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/4/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/5/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/5/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/6/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/6/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/7/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/7/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/8/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/8/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/9/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/9/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/10/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/10/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/11/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/11/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/12/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/12/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/13/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/13/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/14/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/14/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/15/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/15/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/16/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/16/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/17/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/17/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/18/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/18/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/19/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/19/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/20/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/20/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/21/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/21/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/22/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/22/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/23/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/23/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/24/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/24/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/25/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/25/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/26/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/26/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/27/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/27/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/28/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/28/avatar.svg"></a>
<a href="https://opencollective.com/openfarm/sponsor/29/website" target="_blank"><img src="https://opencollective.com/openfarm/sponsor/29/avatar.svg"></a>

### Software License

The MIT License (MIT)

Copyright (c) 2014 Farmbot Project, et. al. [(http://go.farmbot.it/)](http://go.farmbot.it/).

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Data License

All data within the OpenFarm.cc database is in the [Public Domain (CC0)](creativecommons.org/publicdomain/zero/1.0/).
