# Web Feed Formats


## RSS 2.0

### Feed

**Required Feed Elements**

1. title
2. link
3. description

Note: title and description assume plain text


**More Feed Elements (Optional)**

- lastBuildDate (Date in RFC 822 format e.g. Sat, 07 Sep 2002 09:42:31 GMT)

Note: similar to Atom updated

- pubDate    (Date in RFC 822 format e.g. Sat, 07 Sep 2002 00:00:01 GMT)

Note: same as pubDate in items ??; if no pubDate in item - use pubDate in feed??
is that the intention??   - same as latest pubDate in items ???


###  RSS 2.0 In the Wild:

**New York Times**

~~~
<title>NYT &gt; Technology</title>
<link>http://www.nytimes.com/pages/technology/index.html?partner=rss&amp;emc=rss</link>
<description>Technology</description>

<pubDate>Thu, 15 Jan 2015 12:33:42 GMT</pubDate>
<lastBuildDate>Thu, 15 Jan 2015 12:33:42 GMT</lastBuildDate>
~~~

**Site Point**

~~~
<title>SitePoint &#187; Ruby</title>
<link>http://www.sitepoint.com</link>
<description>
      Learn CSS &#124; HTML5 &#124; JavaScript &#124; Wordpress &#124;
      Tutorials-Web Development &#124; Reference &#124; Books and More
</description>

<lastBuildDate>Thu, 15 Jan 2015 04:08:51 +0000</lastBuildDate>
~~~


### Items

**Required Item Elements**

1. title
2. link
3. description

or

1. description (full html-escaped content)


**More Feed Elements (Optional)**

- pubDate   (Date in RFC 822 format e.g. Sat, 07 Sep 2002 00:00:01 GMT)

- author

Note: only one author element allowed (supported) - Atom supports one or many



## Date Formats

RFC 822

- Sat, 07 Sep 2002 09:42:31 GMT

Note: check if time zone is always GMT (UTC)???


## Feed Dates

**Atom**

Date format in ISO 801 ?? e.g.  2015-11-11T17:11Z   ??

- updated        - required?  (preferred?)
- published ???  - also used/allowed? in feed

**RSS 2.0**

Date format in RFC 822  (like in HTTP Headers ???)  e.g. Sat, 07 Sep 2002 09:42:31 GMT

- lastBuildDate     - preferred (assume same as Atom updated)
- pubDate           - (sometime also used - same as latest items.pubDate ??)


## Feed Summaries & Subtitles

**Atom**

- subtitle   (allows @type ?? e.g. html,escaped,xhtml,text - default? )

**RSS 2.0**

- description  (no attribs; assumes plain text)




### References

**Atom**

**RSS**

- [RSS 2.0 Spec](http://cyber.law.harvard.edu/rss/rss.html)



### Misc

AT&T  - check how encoded in title in XML ??

