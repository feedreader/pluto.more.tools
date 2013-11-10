# encoding: utf-8

require 'pluto'


Pluto.connect!   # try connect w/ DATABASE_URL


include Pluto::Models

fetcher = Fetcher::Worker.new


class Report
  def initialize
    @buf = StringIO.new
    @buf.puts "//// REPORT ////////////////////"
    @buf.puts ""
  end

  def puts( msg )
    STDOUT.puts msg    # echo to stdout while filling up buffer/report
    @buf.puts( msg )
  end
  
  def string
    @buf.string
  end
end


o = Report.new


Feed.order(:id).each do |feed|
  
  o.puts "====== #{feed.url} ======"
  o.puts ""

  res = fetcher.get( feed.url )

  if res.code == '200'
    html = res.body
    ## todo: force utf-8 usage

    o.puts "title -- >|#{feed.title}|<"

    ## check for title
    md = html.match( /<title.*?>.*<\/title>/im )
    
    ## report - no title
    ##       or  title do not match

    if md
      o.puts "      -- >|#{md[0]}|<"
    else
      o.puts "!!! title missing"
    end


    ## check for feed links / autodiscovery
    #  e.g. <link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="http://www.meetup.com/vienna-rb/events/rss/vienna.rb/" />

    o.puts "feed -- >|#{feed.feed_url}|<"

    link_count=0

    html.scan( /<link[^>]+alternate[^>]+>/im ) do |link|
      # note: link is "plain" matched string (not regex match data array)
      # from ruby string docu:
      # - If the pattern contains no groups, each individual result
      #  consists of the matched string, 
      # note: different w/ capture groups ()!!

      link_count += 1
      ## puts "#{link.class.name}"
      o.puts "     [#{link_count}] >|#{link}|<"
    end

    ### report - no link
    #         or more than one link
    #         or link do not match

    if link_count == 0
      o.puts "!!! link (alternate/auto discovery) missing"
    end
    
    if link_count > 1
      o.puts "!!! more than one link (alternate/auto discovery) found"
    end


=begin
    ## check for meta keywords
    # e.g. <meta name="keywords" content="Austria,Vienna,Open Source,rubyist,group,club,event,community,meetup" />

    md = html.match( /<meta[^>]+name[^>]+keywords[^>]+>/im )
    puts "keywords -- >|#{md[0]}|<"   if md

    ## check for meta description
    # e.g. <meta name="description" content="User group for Viennese Ruby developers and Rails aficionados.http://vienna-rb.at" />

    md = html.match( /<meta[^>]+name[^>]+description[^>]+>/im )
    puts "description -- >|#{md[0]}|<"   if md

    ## check for meta author
    # e.g  <meta name="author" content="Franz Muster" />
=end


  else
    o.puts "!!! error: fetching site >#{feed.url}< - #{res.code} #{res.message}"
  end

  o.puts ""

end  # each feed

puts o.string
