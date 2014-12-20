# encoding: utf-8


require 'logutils'
require 'fetcher'
require 'feedutils'
require 'active_support/all'      # for Hash.from_xml



### our own code

require './config'



puts "hello from converting planet config"


logger = LogUtils::Logger.root
logger.level = :debug


def fetch_opml( opml_str )
  worker = Fetcher::Worker.new

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
end



# 'http://planet.mozilla.org/opml.xml'
# 'http://blogs.openstreetmap.org/opml.xml'
# Note: Ruby's first program argument is zero e.g. ARGV[0]
opml_str = ARGV[0] || 'http://blogs.openstreetmap.org/opml.xml'

xml = fetch_opml( opml_str ) 
planet = OpmlBuilder.build( xml )


planet.update   ## fetch all feeds and update titles etc.
 
planet.save_file( 'planet.ini' )

