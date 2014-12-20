# encoding: utf-8



class PlanetConfig
  
  attr_accessor :title
  attr_accessor :author
  attr_accessor :email
  attr_accessor :feeds


  def update
    ###
    ## try to fetch feed and get link for site/blog

    worker = Fetcher::Worker.new

    @feeds.each do |feed|

     begin
      res = worker.get_response( feed.feed )
      puts "#{res.code} #{res.message}"

      if res.code != '200'  # Note: res.code (HTTP status code) is a string
        puts "*** sorry; failed to fetch feed"
        feed.errors = "failed to fetch feed - HTTP #{res.code} #{res.message}"
        next
      end

      xml = res.body
      xml = xml.force_encoding( Encoding::UTF_8 )

      synd = FeedUtils::Parser.parse( xml )
      puts "  format: #{synd.format}"
      puts "  title:  #{synd.title}"
      puts "  url:    #{synd.url}"

      feed.link       = synd.url   # ## use/change to auto_link - why? why not??
      feed.format     = synd.format
      feed.generator  = synd.generator  # check version and uri if present? add too?
      feed.generator << " @version=#{synd.generator_version}"  if synd.generator_version
      feed.generator << " @uri=#{synd.generator_uri}"  if synd.generator_uri
      feed.auto_title = synd.title

     rescue Exception => e
      puts "*** sorry; failed to fetch feed - [#{e.class.name}] #{e.to_s}"
      ## Note: replace newline in multi-line messages e.g.
      ##
      # This is not well formed XML
      # Missing end tag for 'link' (got "head")
      # Line: 11
      # Position: 522
      # Last 80 unconsumed characters:
      #    becomes
      # This is not well formed XML | Missing end tag for 'link' (got "head") | Line: 11 | Position: 522 | Last 80 unconsumed characters: 
      #

      feed.errors = "failed to fetch feed - except [#{e.class.name}] #{e.to_s.gsub("\n",' | ')}"
      next
     end
    end
  end # method update


  def save_file( fn='planet.ini' )

    File.open( fn, 'w') do |f|
      f.puts "## Planet Pluto Configuration"
      f.puts "##   auto-generated on #{Time.now}"
      f.puts
      f.puts "title  = #{title}"
      f.puts "author = #{author}"
      f.puts "email  = #{email}"
      f.puts
      f.puts

      feeds.each do |feed|
        f.puts "[#{feed.key}]"
        f.puts "  title = #{feed.title}"
        f.puts "  feed  = #{feed.feed}"
        f.puts "  link  = #{feed.link}"  unless feed.link.blank?
        f.puts "  ## #{feed.format}; #{feed.generator}"    unless feed.format.blank?
        f.puts "  ## #{feed.auto_title}"  unless feed.auto_title.blank?
        f.puts "  ## #{feed.comments}"  unless feed.comments.blank?
        f.puts "  ## *** error: #{feed.errors}"  unless feed.errors.blank?
        f.puts
      end
    end
  end # method save_file


end # class PlanetConfig


FeedConfig =   Struct.new( :key,
                           :title,
                           :feed,
                           :link,
                           :format,
                           :generator,
                           :auto_title,
                           :errors,
                           :comments)



class OpmlBuilder

  def self.build( xml )
    ## pp xml
    h = Hash.from_xml(xml)
    ## pp h

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
    planet
  end

end # class OpmlBuilder



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

