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

...
...

### Contributors

...
...

### License

...
...
