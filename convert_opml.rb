# encoding: utf-8


require 'logutils'
require 'fetcher'
require 'active_support/all'      # for Hash.from_xml


puts "hello from converting planet config"


logger = LogUtils::Logger.root
logger.level = :debug


worker = Fetcher::Worker.new

opml_str = ARGV[1] || 'http://blogs.openstreetmap.org/opml.xml'

res = worker.get_response( opml_str )

puts "#{res.code} #{res.message}"

if res.code != '200'  # Note: res.code (HTTP status code) is a string
  puts "sorry; failed to fetch opml feed"
  exit(1)
end

xml = res.body

###
# Note: Net::HTTP will NOT set encoding e.g. to UTF-8 etc.
#  will be ASCII; change encoding to UTF-8
xml = xml.force_encoding( Encoding::UTF_8 )

## pp xml
h = Hash.from_xml(xml)
## pp h


def sanitize_title( title )
###
# todo: unescape (all) html entities in title
#   e.g. &amp;  to &

  title = title.gsub( '&amp;', '&' )
  title = title.gsub( /["]/, '')  # remove double quotes
  title
end


def title_to_key( title )
  
  ### fix: use textutils.title_to_key ??
  key = title.downcase
  key = key.gsub( 'ü', 'ue' )
  key = key.gsub( 'é', 'e' )

  key = key.gsub( /[^a-z0-9]/, '' )  ## for now remove all chars except a-z and 0-9
  
  if key.blank?   ## note: might result in null string (use timestamp)
    key = "feed#{Time.now.strftime('%Y%m%d%H%M%S%L')}"
  end

  key
end


PlanetConfig = Struct.new(:title,
                          :author,
                          :email,
                          :feeds)

FeedConfig =   Struct.new( :key,
                           :title,
                           :feed,
                           :link,
                           :comments)

planet = PlanetConfig.new
planet.title  = h['opml']['head']['title']
planet.author = h['opml']['head']['ownerName']
planet.email  = h['opml']['head']['ownerEmail']
planet.feeds  = []

h['opml']['body']['outline'].each do |outline|
  feed = FeedConfig.new
  feed.title = sanitize_title( outline['text'] )   ###outline['title']
  feed.feed  = outline['xmlUrl']
  feed.key   = title_to_key( feed.title )
  planet.feeds << feed
end

###
## try to fetch feed and get link for site/blog

planet.feeds.each do |feed|

 begin
  res = worker.get_response( feed.feed )
  puts "#{res.code} #{res.message}"
  
  if res.code != '200'  # Note: res.code (HTTP status code) is a string
    puts "*** sorry; failed to fetch feed"
    feed.comments = "*** error: failed to fetch feed - HTTP #{res.code} #{res.message}"
    next
  end

  xml = res.body
  xml = xml.force_encoding( Encoding::UTF_8 )

 rescue Exception => e
   puts "*** sorry; failed to fetch feed - #{e.to_s}"
   feed.comments = "*** error: failed to fetch feed - except #{e.to_s}"
   next
 end

end


File.open( 'planet.ini', 'w') do |f|
  f.puts "## Planet Pluto Configuration"
  f.puts "##   auto-generated from #{opml_str}"
  f.puts "##   on #{Time.now}"
  f.puts
  f.puts "title  = #{planet.title}"
  f.puts "author = #{planet.author}"
  f.puts "email  = #{planet.email}"
  f.puts
  f.puts

  planet.feeds.each do |feed|
    f.puts "[#{feed.key}]"
    f.puts "  title = #{feed.title}"
    f.puts "  feed  = #{feed.feed}"
    f.puts "  ## #{feed.comments}"  unless feed.comments.blank?
    f.puts
  end
end


