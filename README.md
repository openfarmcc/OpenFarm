[![Coverage Status](https://img.shields.io/coveralls/openfarmcc/OpenFarm.svg)](https://coveralls.io/r/openfarmcc/OpenFarm)
[![Code Climate](https://codeclimate.com/github/openfarmcc/OpenFarm/badges/gpa.svg)](https://codeclimate.com/github/FarmBot/OpenFarm)
[![Issue Stats](http://issuestats.com/github/openfarmcc/openfarm/badge/pr)](http://issuestats.com/github/openfarmcc/openfarm)
[![Issue Stats](http://issuestats.com/github/openfarmcc/openfarm/badge/issue)](http://issuestats.com/github/openfarmcc/openfarm)
OpenFarm
========

[OpenFarm](http://openfarm.cc) is a free and open database and web application for farming and gardening knowledge. One might think of it as the Wikipedia or Freebase for growing plants, though it functions more like a cooking recipes site. The main content are Growing Guides: creative, crowd-sourced, single-author, structured documents that include all of the necessary information for a person or machine to grow a plant, ie: seed spacing and depth, watering regimen, recommended soil composition and companion plants, sun/shade requirements, etc.

Other use cases: a mobile app for home gardeners, Google providing "One Box" answers to search queries such as "How do I grow tomatoes", smart garden sensors, automated farming machines.

### Core Contributor Group

We use [Slack](https://openfarm.slack.com/) for real-time discussion and mockup sharing among the core team. We strongly recommend joining this group if you want to get involved and meet the other contributors. All you have to do is enter your email into [this form](http://goo.gl/forms/ZqBdmN2nu2) or [email Rory](mailto:rory@openfarm.cc) with your email address and he'll send you an invitation to join!

### Community Discussion Group

For discussing features, feature requests and ideas, and interfacing with our users at large (and contributors not on GitHub), please check out our public [discussion forum](https://www.loomio.org/g/yWm14fG6/openfarm-community-development-group).

### Getting Started (Setup)

You will need [Ruby](http://www.ruby-lang.org/en/), [Rails](http://rubyonrails.org/), [ElasticSearch](http://www.elasticsearch.org/) and [Mongodb](http://docs.mongodb.org/manual/installation/) installed before continuing. Once you have these prerequisites to get started with a local copy of the project, run:

```bash
$ git clone https://github.com/openfarmcc/OpenFarm.git
$ cd OpenFarm
$ bundle install
$ rake db:setup
$ echo "ENV['SECRET_KEY_BASE'] = '$(rake secret)'" >> config/app_environment_variables.rb
$ rails s
```

If all went well, you will have a seeded database and can use the account `admin@admin.com` with password `admin123`.

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

We encourage everyone to contribute! From newbies to pros, to people who don't write software, to those with just a few ideas to share - we greatly appreciate everyone's input and are happy to help you help us. We strive for diversity on our team and are dedicated to making a safe space and community for everyone. To help us ensure this, We have created and adopted a [Code of Conduct](https://openfarm.cc/pages/code_of_conduct?locale=en).

Here are our [current contributors](https://github.com/openfarmcc/OpenFarm/graphs/contributors) here on GitHub.

### Software License

The MIT License (MIT)

Copyright (c) 2014 Farmbot Project, et. al. [(http://go.farmbot.it/)](http://go.farmbot.it/).

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Data License

All data within the OpenFarm.cc database is in the [Public Domain (CC0)](creativecommons.org/publicdomain/zero/1.0/).
