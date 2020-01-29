#######################
#  to run type:
#    $ ruby ./parse_feed.rb


###############
#   feed (atom) without generator tag

require 'feedparser'

xml = <<TXT
<?xml version="1.0" encoding="UTF-8"?>
<feed xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xml:lang="en-US">
  <id>tag:github.com,2008:/organizations/Unvanquished</id>
  <link type="text/html" rel="alternate" href="https://github.com/organizations/Unvanquished/dashboard"/>
  <link type="application/atom+xml" rel="self" href="https://unvanquished.net/activity/feed/Unvanquished"/>
  <title>Unvanquished activity</title>
  <updated>2020-01-27T02:52:25Z</updated>
</feed>
TXT

feed = FeedParser::Parser.parse( xml )
pp feed


pp feed.generator
pp feed.generator.to_s
puts "#{feed.generator}"

value = feed.generator
puts "#{value} #{value.class.name}"
value = feed.generator.to_s
puts "#{value} #{value.class.name}"

