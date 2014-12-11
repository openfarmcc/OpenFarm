[![Coverage Status](https://img.shields.io/coveralls/openfarmcc/OpenFarm.svg)](https://coveralls.io/r/openfarmcc/OpenFarm)
[![Code Climate](https://codeclimate.com/github/openfarmcc/OpenFarm/badges/gpa.svg)](https://codeclimate.com/github/FarmBot/OpenFarm)
[![Issue Stats](http://issuestats.com/github/openfarmcc/openfarm/badge/pr)](http://issuestats.com/github/openfarmcc/openfarm)
[![Issue Stats](http://issuestats.com/github/openfarmcc/openfarm/badge/issue)](http://issuestats.com/github/openfarmcc/openfarm)
OpenFarm
========

[OpenFarm](http://openfarm.cc) is a free and open database and web application for farming and gardening knowledge. One might think of it as the Wikipedia or Freebase for growing plants, though it functions more like a cooking recipes site. The main content are Growing Guides: creative, crowd-sourced, single-author, structured documents including all of the necessary paramaters for a person or machine to grow a plant, ie: seed spacing and depth, watering regimen, recommended soil composition and companion plants, sun/shade requirements, etc.

This project is closely related to the [FarmBot Project](http://go.farmbot.it) but also distinctly separate. OpenFarm is a standalone database that will simply provide data to other applications such as FarmBot.

Other use cases: a mobile app for home gardeners, Google providing "One Box" answers to search queries such as "How do I grow tomatoes", etc.

### Community Discussion Group

For discussing features, feature requests and ideas, and interfacing with our users at large (and contributors not on GitHub), please check out our public [Loom.io group](https://www.loomio.org/g/yWm14fG6/openfarm-community-development-group)

### Core Contributor Group

We're currently [trying out Slack](https://openfarm.slack.com/) for real-time discussion and mockup sharing among the core team. We strongly recommend joining this group if you want to get involved and meet the other contributors. All you have to do is [email Rory](mailto:rory@openfarm.cc) with your email address and he'll send you an invitation to join!

### Getting Started (Setup)

You will need [Ruby](http://www.ruby-lang.org/en/), [Rails](http://rubyonrails.org/), [ElasticSearch](http://www.elasticsearch.org/) and [Mongodb](http://docs.mongodb.org/manual/installation/) installed before continuing. Once you have these prerequisites to get started with a local copy of the project, run:

```bash
$ git clone https://github.com/openfarmcc/OpenFarm.git
$ cd OpenFarm
$ bundle install
$ rake db:setup
$ rails s
```

If all went well, you will have a seeded database and can use the account `admin@admin.com` with password `admin123`.

**If you had any problems** installing bundles getting up and running etc see the [Common Issues Page](https://github.com/openfarmcc/OpenFarm/wiki/Common-Issues).

#### Sensitive Information

All secrets (such as S3 credentials) are stored in ENV variables. You will need to set `config/app_environment_variables.rb` accordingly. See `config/app_environment_variables.rb.example` for an example.

#### Style Guides and formatting.

 * We use the [ThoghtBot Style Guide](https://github.com/thoughtbot/guides/tree/master/style) when writiting Ruby. The exception to this is that we use 'single quotes' instead of "double quotes".
 * When designing API endpoints, follow the [JSONAPI.org formatting guide](http://jsonapi.org/format/)
 * Please write specs for your code. We use Rspec as our testing framework.

### How to Contribute

 1. Fork this repo.
 2. Fix stuff, write features, unit tests(!).
 3. Send pull request to master.

Not sure where to help? Take a look at the issues thread. It is advisable to let other know your intent to implement a feautre before starting, as it lets other contributors focus their efforts elsewhere.

### FAQ

Have a look at the [FAQ](https://github.com/openfarmcc/OpenFarm/wiki/FAQ) for some frequently asked questions about contributing (Angular, Issue Trackers, IRC Channels).

### User Flow

![User Flow Diagram] (http://i.imgur.com/YowIq1N.jpg)

![Information Architecture Diagram] (http://i.imgur.com/qZzF4OZ.jpg)

### Mockups

To view the most recent mockups, click [here] (https://drive.google.com/open?id=0B-wExYzQcnp3cVZvZ3JXb3FDZTg&authuser=0)

### Contributors

[https://github.com/FarmBot/OpenFarm/graphs/contributors](https://github.com/FarmBot/OpenFarm/graphs/contributors)

### License

The MIT License (MIT)

Copyright (c) 2014 Farmbot Project, et. al. [(http://go.farmbot.it/)](http://go.farmbot.it/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Data License

All data within the OpenFarm.cc database is in the [Public Domain (CC0)](creativecommons.org/publicdomain/zero/1.0/)
