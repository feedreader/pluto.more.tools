require 'pp'
require 'erb'
require 'ostruct'
require 'date'
require 'time'
require 'cgi'



class ErbTemplate
  class Context < OpenStruct
    ## use a different name - why? why not?
    ##  e.g. to_h, to_hash, vars, locals, assigns, etc.
    def get_binding() binding; end

    ## add builtin helpers / shortcuts
    def h( text ) CGI.escapeHTML( text ); end
  end


  def initialize( text )
    @template = ERB.new( text )
  end

  def render( hash={} )
    ## note: Ruby >= 2.5 has ERB#result_with_hash - use later - why? why not?
    @template.result( Context.new( hash ).get_binding )
  end
end



template = ErbTemplate.new( <<TXT )
 hello, world!
 <%= Date.today %>
 <%= site %>
 <%= config %>

 <%= CGI.escapeHTML( site ) %>
 <%= CGI.h( site ) %>
 <%=h site %>
TXT

template2 = ErbTemplate.new( <<TXT )
 hello, world v2!
 <%= Date.today %>
TXT


puts CGI.escapeHTML( %Q{hello &&& <>"quote"---} )
puts CGI.h( %Q{hello &&& <>"quote"---} )


### note:  key MUST be strings for Liquid (and NOT symbols!!!)
locals = { 'site'   => 'site & here',
           'config' => 'config & here' }

puts page = template.render( locals )
puts page = template2.render

puts "bye"


