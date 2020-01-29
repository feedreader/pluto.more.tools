#######################
#  to run type:
#    $ ruby sandbox/parse_feed_03.rb



require 'feedparser'

############
#   trouble with &amp; in  link and guid
#    gets converted to &?
#
#  <link>http://www.openstreetmap.org/user/Harvest%20Moon%20Yakitori%20&amp;%20Beer%20Garden/diary/41379</link>
#  <guid>http://www.openstreetmap.org/user/Harvest%20Moon%20Yakitori%20&amp;%20Beer%20Garden/diary/41379</guid>


xml = <<TXT
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
  <title>test title here</title>
  <link>http://www.openstreetmap.org/user/Harvest%20Moon%20Yakitori%20&amp;%20Beer%20Garden/diary/41379</link>
  <guid>http://www.openstreetmap.org/user/Harvest%20Moon%20Yakitori%20&amp;%20Beer%20Garden/diary/41379</guid>
  <lastBuildDate>Sat, 26 Nov 2016 07:03:17 +0000</lastBuildDate>
</channel>
</rss>
TXT


feed = FeedParser::Parser.parse( xml )
pp feed

