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



def find_title_tag( html )
  match_data = html.match( /<title[^>]*>.*<\/title>/im )

  # note: regex match if no match returns match_data == nil
  
  match_data ? match_data[0] : nil
end


def find_feed_link_tags( html )

  links = []   # returns array of strings or empty array

  html.scan( /<link[^>]+alternate[^>]+>/im ) do |link|
      # note: link is "plain" matched string (not regex match data array)
      # from ruby string docu:
      # - If the pattern contains no groups, each individual result
      #  consists of the matched string, 
      # note: different w/ capture groups ()!!

      # note: check if type is
      #   text/xml    - possible? allow for now
      #   application/rss+xml
      #   application/atom+xml
      #   application/rdf+xml
      #  
      #  skip  alternate stylesheet  for example, w/ type  text/css etc.

      ## for now just check if type include xml or rss or atom or rdf
      if link =~ /type=['"][^'"]+(rdf|rss|atom|xml)/i
        links << link.dup 
      else
        puts "!!! skipping candidate link (alternate) |>#{link}<| - type expected w/ rdf|rss|atom|xml"
      end
  end

  links
end

def find_more_feed_link_tags( html )
  links = []

  html.scan( /<a[^>]+href[^>]+>/im ) do |link|

    ## check "plain" anchor <a> links
    #   e.g.
    #   <a href="/feed.xml">news</a>
    #   <a href="/atom.xml">news</a>
    #   <a href="/rss.xml">news</a>
    #   <a href="/rss2.xml">news</a>
    #   <a href="/news.rss">news</a>
    #   <a href="/news.atom">news</a>
    #   <a href="/blog.atom">news</a>

    ## for now just check if type include xml or rss or atom or rdf
    if link =~ /href=['"][^'"]*(feed\.xml|atom\.xml|rss\.xml|rss2\.xml|news\.rss|news\.atom|blog\.atom)/i
        links << link.dup 
    else
        puts "!!! skipping candidate link (anchor) |>#{link}<|"
    end
  end
  links
end





Feed.order(:id).each do |feed|

  o.puts "====== #{feed.url} ======"
  o.puts ""

  res = fetcher.get( feed.url )

  if res.code == '200'
    html = res.body
    ## todo: force utf-8 usage

    o.puts "title -- >|#{feed.title}|<"

    ## check for title
    title = find_title_tag( html )

    if title
      o.puts "      -- >|#{title}|<"
    else
      o.puts "!!! title missing"
    end


    ## check for feed links / autodiscovery
    #  e.g. <link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="http://www.meetup.com/vienna-rb/events/rss/vienna.rb/" />

    o.puts "feed -- >|#{feed.feed_url}|<"

    links = find_feed_link_tags( html )

    links.each_with_index do |link,index|
      o.puts "     [#{index+1}] >|#{link}|<"
    end

    ### report - no link
    #         or more than one link
    #         or link do not match

    if links.size == 0
      o.puts "!!! link (alternate/auto discovery) missing"
    end

    if links.size > 1
      o.puts "!!! more than one link (alternate/auto discovery) found"
    end

    ## check for non-auto discovery plain links using a heuristic (e.g. atom.xml, etc.)
    links = find_more_feed_link_tags( html )
    links.each_with_index do |link,index|
      o.puts "     ++ [#{index+1}] >|#{link}|<"
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
