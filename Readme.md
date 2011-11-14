PowProxy
========

PowProxy is a simple rack-based proxy that allows you to run your node apps through [Pow](http://pow.cx).

PowProxy is based on a blog post by [Assaf Arkin](/assaf). It's super easy to use. You really should just read [Assaf's blog post](http://labnotes.org/2011/08/09/using-pow-with-your-node-js-project/) to get the full explanation.

Installation
------------

    (sudo) gem install pow_proxy

Usage
-----

Create a `config.ru` file in your project's root with the following:

```ruby
require 'pow_proxy'
run PowProxy.new
```

By default, it assumes the host to be `localhost` and the port to be `3000` however you can configure that to be anything you'd like:

```ruby
require 'pow_proxy'
run PowProxy.new(:host => '127.0.0.1', :port => 8080)
```

You can also set the host and port by exporting the `POW_PROXY_HOST` and `POW_PROXY_PORT` environment variables in your `.powenv`.

Make sure your node app is running, symlink your app so that Pow knows about it and you'll be all set.

Copyright
---------

Copyright (c) 2011 Steve Agalloco, Assaf Arkin. See [LICENSE](https://github.com/spagalloco/pow_proxy/blob/master/LICENSE.md) for details.