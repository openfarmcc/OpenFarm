![OpenFarm](https://cloud.githubusercontent.com/assets/10438537/13198846/445ddeb2-d7d1-11e5-8e11-163e0545909a.jpg)

[![Coverage Status](https://img.shields.io/coveralls/openfarmcc/OpenFarm.svg)](https://coveralls.io/r/openfarmcc/OpenFarm)
[![Code Climate](https://codeclimate.com/github/openfarmcc/OpenFarm/badges/gpa.svg)](https://codeclimate.com/github/FarmBot/OpenFarm)
[![OpenCollective](https://opencollective.com/openfarm/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/openfarm/sponsors/badge.svg)](#sponsors)
[![OpenFarm Gitten](http://gittens.r15.railsrumble.com//badge/openfarmcc/OpenFarm)](http://gittens.r15.railsrumble.com/gitten/openfarmcc/OpenFarm)

Open Source community of contributors: how it works
========

### Shortcuts
Already contributing to OpenFarm? You're welcome to [introduce yourself]((https://docs.google.com/forms/d/e/1FAIpQLSfsKUABGJSO3gSfDUrdXymxP-GipdTLxbxsmR2FyxGdblN1-w/viewform))!
Want to dig head first into our todo list of Github tasks? [Make yourself at home](https://github.com/openfarmcc/OpenFarm/projects)!


### About

[OpenFarm](http://openfarm.cc) is a free and open database and web application for farming and gardening knowledge. One might think of it as the Wikipedia for growing plants, though it functions more like a cooking recipes site. The main content are Growing Guides: creative, crowd-sourced, single-author, structured documents that include all of the necessary information for a person or machine to grow a plant, i.e.: seed spacing and depth, watering regimen, recommended soil composition and companion plants, sun/shade requirements, etc. In this Freebase platform, gardeners can find answers to questions like &ldquo;How do I grow tomatoes?&rdquo; 

### Start by joining the discussion of existing Contributors

To start the discussion, get involved, and meet OpenFarm core community of contributors, we strongly recommend joining [our Slack room](http://slack.openfarm.cc/)!. This is where you'll find the latest conversation about Openfarm and the core. 

As an alternative, you can ask quick questions on [IRC on Freenode #openfarmcc](https://webchat.freenode.net/?channels=openfarmcc). The room might look empty but we have a bot piping messages back and forth with Slack.

Check also the [FAQ](http://openfarm.cc/pages/faq) for some frequently asked questions about contributing (Angular, Issue Trackers, IRC Channels).

Check the [ongoing issues](https://github.com/openfarmcc/OpenFarm/projects) to be built first.

### Look for something you want to work on

For [front-end](https://github.com/openfarmcc/OpenFarm/projects/1) and [back-end] (https://github.com/openfarmcc/OpenFarm/projects/3) code contributions, we aim at maintaining and prioritizing the Github issues through Github Projects, the Trello-like web-based project management board of Github: [OpenFarm Projects](https://github.com/openfarmcc/OpenFarm/projects) 

Need to use OpenFarm Assets? [Here they are](https://drive.google.com/open?id=0B-wExYzQcnp3cGphOGZQS1lBRFk)!

We have few more languages missing for the website content to be translated: help us [translate the website](https://www.transifex.com/projects/p/openfarm/)!

### Who can contribute

Everyone is welcome to bring value to the Open Source community of OpenFarm. Time is our most valuable assets here, so any minute of your time counts to make things happen! "Better done, than perfect!"
We strive for diversity in our community and want to ensure we provide a safe and inclusive space for everyone by adopting a [Code of Conduct](https://openfarm.cc/pages/code_of_conduct?locale=en).

Our community is composed of tech and non-tech folks, newbie as well as experts in gardening, overall great people willing to take actions for a better future and sharing knowledge and growing our own food.

### Our problem-solving process

On the way we work together, we aim at:
- having transparency in reasoning behind actions: taking time for documentation, questions and answers
- prefering done, than perfect: breaking down tasks so that anyone can contribute few min of their time on a regular basis
- taking shortcuts: what's the most obvious for a better usability? what's the shortest way to build a feature? What's the most valuable inputs for a feedback?

### User Flow

Update in progress

### Mockups

Update in progress

## Development

### Getting Started (The Easy Way)

You should use Vagrant to get the OpenFarm system running on your computer. It will avoid having to install the things listed in The Hard Way below.

1. Install [Vagrant](https://www.vagrantup.com/docs/installation/).
2. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
3. Open your terminal.
4. `$ git clone https://github.com/openfarmcc/OpenFarm.git` - this tells your computer to fetch the data stored in this repository using git.
5. `$ cd OpenFarm` - change to the OpenFarm directory
6. `$ vagrant up` This will take a long time. We're downloading a whole bunch of stuff. Go make yourself a pot of coffee, or brew some tea. If something goes wrong at this point, reach out to Simon directly at [slack.openfarm.cc](http://slack.openfarm.cc/).

#### Accessing Vagrant

Once Vagrant is set up on your system, you might want to actually access it. For example, if you want to start up the server (though vagrant up should run `rails s` for you):

8. `$ vagrant ssh` - this makes you access the new virtual server we just created to run OpenFarm on.
9. `cd /vagrant` - the `vagrant` directory is mirrored in your own computer. If you add a file there, you'll see it appear here.
10. `rails s` - actually run the Rails server!
11. you should now be able to access OpenFarm on your local system at http://localhost:3000. If all went well, you will have a seeded database and can use the account `admin@admin.com` with password `admin123`.

The above is still being patched, so please reach out to us if something went wrong!

### Getting Started (The Hard Way)

You will need to install [Ruby](http://www.ruby-lang.org/en/), [Rails](http://rubyonrails.org/), [ElasticSearch](http://www.elasticsearch.org/) [v1.4.5](https://www.elastic.co/downloads/past-releases/elasticsearch-1-4-5), and [Mongodb](http://docs.mongodb.org/manual/installation/) before you can get an OpenFarm server up and running on your local machine. Once you have these prerequisites to get started with a local copy of the project, run:

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

**If you had any problem** installing bundles getting up and running etc see the [Common Issues Page](https://github.com/openfarmcc/OpenFarm/wiki/Common-Issues).

#### Become a Core Contributors

If you've made two PRs, we'll add you as a core contributor.

For core-code contributors: here are a few basic ground-rules:

* No --force pushes or modifying the Git history in any way.
* Non-master branches ought to be used for ongoing work.
* External API changes and significant modifications ought to be subject to an internal pull-request to solicit feedback from other contributors.
* Internal pull-requests to solicit feedback are encouraged for any other non-trivial contribution but left to the discretion of the contributor.
* Contributors should attempt to adhere to the prevailing code-style.

([based on the OPEN open source model](https://github.com/Level/community/blob/master/CONTRIBUTING.md))

[Further reading](https://medium.com/the-javascript-collection/healthy-open-source-967fa8be7951#.alkpecsnd)

### Actual Code Contributors

Here are some of the [Github contributors](https://github.com/openfarmcc/OpenFarm/graphs/contributors). 

Outside of Github, there's a whole host of people who also contributed financially, by building gardening content on the website, on providing more visibility for OpenFarm in any ways!

You've been contributing to OpenFarm already? We invite you to introduce yourself in this 2-min [Welcoming Form]!(https://docs.google.com/forms/d/e/1FAIpQLSfsKUABGJSO3gSfDUrdXymxP-GipdTLxbxsmR2FyxGdblN1-w/viewform)

### Donate to OpenFarm as a Backer

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


### Support OpenFarm as a Sponsor

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

Copyright (c) 2014 Farmbot Project, et. al. [(http://farmbot.io/)](http://farmbot.io/).

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Data License

All data within the OpenFarm.cc database is in the [Public Domain (CC0)](http://creativecommons.org/publicdomain/zero/1.0/).
