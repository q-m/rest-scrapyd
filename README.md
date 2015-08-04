rest-scrapyd
============
[![Gem Version](https://badge.fury.io/rb/rest-scrapyd.svg)](http://badge.fury.io/rb/rest-scrapyd)
[![Documentation](http://b.repl.ca/v1/yard-docs-blue.png)](http://rubydoc.info/github/q-m/rest-scrapyd)

Ruby client for the [Scrapyd](http://scrapyd.readthedocs.org/) REST API
built on top of [rest-core](https://github.com/godfat/rest-core).


Installation
------------

```sh
gem install rest-scrapyd
```

or, when using a Gemfile

```ruby
gem 'rest-scrapyd'
```

and run `bundle install`.


Usage
-----

```ruby
require 'rest-scrapyd'

r = RestScrapyd.new site: "http://example.com:6800/"
r.listprojects
# => ["project1", "project2"]
r.listspiders(project: "project1")
# => ["spider1", "spider2"]

# connect to default site at http://localhost:6800/
r = RestScrapyd.new
# and set a default project
r.project = "project1"
r.listspiders
# => ["spider1", "spider2"]
r.listversions
# => ["123456-master"]

# you can also specify a default project on construction
r = RestScrapyd.new project: "project1"
r.schedule("spider1", "123456-master")
# => "1234567890abcdef1234567890abcdef"

# http basic is also possible, when running scrapyd behind a reverse proxy
r = RestScrapyd.new site: "https://example.com:6843/", username: "deploy", password: "s3cret"
```

For more information, see the [RestScrapyd](http://rubydoc.info/github/q-m/rest-scrapyd/RestScrapyd.html)
and [Scrapyd API](http://scrapyd.readthedocs.org/en/latest/api.html) documentation.


Copyright
---------

Copyright © 2015 wvengen, released under the [MIT license](LICENSE).
