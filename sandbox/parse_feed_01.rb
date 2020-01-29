#######################
#  to run type:
#    $ ruby sandbox/parse_feed_01.rb



require 'feedparser'

############
#   "empty" feed (rss 2.0), that is, feed without any entries / items

xml = <<TXT
<?xml version="1.0" encoding="UTF-8"?><rss version="2.0"
	xmlns:content="http://purl.org/rss/1.0/modules/content/"
	xmlns:wfw="http://wellformedweb.org/CommentAPI/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
	xmlns:slash="http://purl.org/rss/1.0/modules/slash/"
	>

<channel>
	<title>gentoo &#8211; gokturk</title>
	<atom:link href="https://blogs.gentoo.org/gokturk/category/gentoo/feed/" rel="self" type="application/rss+xml" />
	<link>https://blogs.gentoo.org/gokturk</link>
	<description>Just another Gentoo Blogs site</description>
	<lastBuildDate>Sat, 26 Nov 2016 07:03:17 +0000</lastBuildDate>
	<language>en-US</language>
	<sy:updatePeriod>
	hourly	</sy:updatePeriod>
	<sy:updateFrequency>
	1	</sy:updateFrequency>
	<generator>https://wordpress.org/?v=5.3.2</generator>
</channel>
</rss>
TXT


feed = FeedParser::Parser.parse( xml )
pp feed

