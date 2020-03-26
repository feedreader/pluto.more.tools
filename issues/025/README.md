# Net::OpenTimeout - Issue 025

reported stacktrace:

```
  /usr/lib/ruby/2.5.0/net/protocol.rb:41:in `ssl_socket_connect': Net::OpenTimeout (Net::OpenTimeout)
  	from /usr/lib/ruby/2.5.0/net/http.rb:985:in `connect'
  	from /usr/lib/ruby/2.5.0/net/http.rb:920:in `do_start'
  	from /usr/lib/ruby/2.5.0/net/http.rb:909:in `start'
  	from /usr/lib/ruby/2.5.0/net/http.rb:1458:in `request'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/fetcher-0.4.5/lib/fetcher/worker.rb:203:in `get_response'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/fetcher-0.4.5/lib/fetcher/worker.rb:56:in `get'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-feedfetcher-0.1.5/lib/pluto/feedfetcher/cond_get_with_cache.rb:34:in `fetch'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-update-1.6.3/lib/pluto/update/feed_refresher.rb:57:in `refresh_feed_worker'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-update-1.6.3/lib/pluto/update/feed_refresher.rb:49:in `block in refresh_feeds_for'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/activerecord-6.0.2.1/lib/active_record/relation/delegation.rb:85:in `each'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/activerecord-6.0.2.1/lib/active_record/relation/delegation.rb:85:in `each'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-update-1.6.3/lib/pluto/update/feed_refresher.rb:48:in `refresh_feeds_for'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-1.3.4/lib/pluto/cli/updater.rb:51:in `update_for'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-1.3.4/lib/pluto/cli/updater.rb:31:in `run'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-1.3.4/lib/pluto/cli/main.rb:232:in `block (3 levels) in <top (required)>'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-1.3.4/lib/pluto/cli/main.rb:208:in `each'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-1.3.4/lib/pluto/cli/main.rb:208:in `block (2 levels) in <top (required)>'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/gli-2.19.0/lib/gli/command_support.rb:131:in `execute'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/gli-2.19.0/lib/gli/app_support.rb:296:in `block in call_command'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/gli-2.19.0/lib/gli/app_support.rb:309:in `call_command'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/gli-2.19.0/lib/gli/app_support.rb:83:in `run'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-1.3.4/lib/pluto/cli/main.rb:390:in `<top (required)>'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/activesupport-6.0.2.1/lib/active_support/dependencies.rb:325:in `require'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/activesupport-6.0.2.1/lib/active_support/dependencies.rb:325:in `block in require'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/activesupport-6.0.2.1/lib/active_support/dependencies.rb:291:in `load_dependency'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/activesupport-6.0.2.1/lib/active_support/dependencies.rb:325:in `require'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-1.3.4/lib/pluto.rb:24:in `main'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/gems/pluto-1.3.4/bin/pluto:5:in `<top (required)>'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/bin/pluto:23:in `load'
  	from /home/user/workspace/Website_planet-kde-org/vendor/ruby/2.5.0/bin/pluto:23:in `<main>'
```

## References

- <https://www.exceptionalcreatures.com/bestiary/Net/OpenTimeout.html>

When you run into Net::OpenTimeout, you should handle it by retrying the request a few times, or giving up and showing a helpful error to the user.

