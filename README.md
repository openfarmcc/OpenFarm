OpenFarm
========

OpenFarm (OpenFarm.cc) is a free and open database for farming and gardening knowledge. One might think of it as the Wikipedia or Freebase for growing plants. The data is crowdsourced and includes all of the necessary paramaters for a machine or human to successfully grow a plant, ie: seed spacing and depth, water regimen, recommended soil composition and companion plants, sun/shade requirements, etc.

This project is closely related to the FarmBot project but also distinctly separate. OpenFarm is a standalone database that will simply provide data to other applications. For FarmBot, OpenFarm will supply the default settings to grow a plant when a user selects it in the graphical FarmBot frontend.

OpenFarm will also have a web frontend of its own to allow Joe Gardener to access the data and make contributions.

Examples of other applications using OpenFarm: a mobile application for home gardeners, Google providing "One Box" answers to search queries such as "How do I grow tomatoes", Wolfram Alpha displaying the data for "growng tomatoes" which is also showed to users asking Siri on iDevices, etc.

User Stories
------------

[![Stories in Ready](https://badge.waffle.io/FarmBot/OpenFarm.png?label=ready)](http://waffle.io/FarmBot/OpenFarm)

### Getting Started (Setup)

You will need [Ruby](http://www.ruby-lang.org/en/), [Rails](http://rubyonrails.org/) and [Mongodb](http://docs.mongodb.org/manual/installation/) installed. To get started with a local copy of the project, run:

```bash
$ git clone https://github.com/FarmBot/OpenFarm.git
$ cd OpenFarm
$ bundle install
$ rake db:setup
$ rails s
```

### How to Contribute

 1. Fork this repo.
 2. Fix stuff, add features.
 3. Send pull request to master.

Not sure where to help? Take a look [over here](http://waffle.io/FarmBot/OpenFarm).

### Contributors

[https://github.com/FarmBot/OpenFarm/graphs/contributors](https://github.com/FarmBot/OpenFarm/graphs/contributors)

### License

The MIT License (MIT)

Copyright (c) 2013 Farmbot Project, et. al. [(http://go.farmbot.it/)](http://go.farmbot.it/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/FarmBot/openfarm/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

