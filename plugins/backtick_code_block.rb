require './plugins/pygments_code'

module BacktickCodeBlock
  include HighlightCode
  AllOptions = /([^\s]+)\s+(.+?)\s+(https?:\/\/\S+|\/\S+)\s*(.+)?/i
  LangEmphasize = /([^\s]+)\s\~\~([0-9,]+)\s*(.+)?/i
  LangCaption = /([^\s]+)\s*(.+)?/i
  def render_code_block(input)
    input.gsub(/^`{3} *([^\n]+)?\n(.+?)\n`{3}/m) do
      @options = nil
      @caption = nil
      @lang = nil
      @url = nil
      @title = nil
      @emphasize = ''

      @options = $1 || ''
      str = $2

      if @options =~ AllOptions
         @lang = $1
         @caption = "<figcaption><span>#{$2}</span><a href='#{$3}'>#{$4 || 'link'}</a></figcaption>"
      elsif @options =~ LangEmphasize
         @lang = $1
         caption = $3
         @emphasize = $2.gsub(',', ' ')
         if !caption.nil?
            @caption = "<figcaption><span>#{caption}</span></figcaption>"
         end
      elsif @options =~ LangCaption
         @lang = $1
         if !$2.nil?
            @caption = "<figcaption><span>#{$2}</span></figcaption>"
         end
      end
      
      if @lang.nil?
         @lang = 'raw'
      end

      if str.match(/\A( {4}|\t)/)
        str = str.gsub(/^( {4}|\t)/, '')
      end
      if @lang == 'raw'
        code = str.gsub('<','&lt;').gsub('>','&gt;')
        "<pre><code>#{code}</code></pre>"
      else
       if @lang == 'plain'
        code = tableize_code(str.gsub('<','&lt;').gsub('>','&gt;'))
        "<figure class='code'>#{@caption}#{code}</figure>"
       else
        if @lang.include? "-raw"
          raw = "``` #{@options.sub('-raw', '')}\n"
          raw += str
          raw += "\n```\n"
        else
          code = highlight(str, @lang, @emphasize)
          "<figure class='code'>#{@caption}#{code}</figure>"
        end
       end
      end
    end
  end
end
