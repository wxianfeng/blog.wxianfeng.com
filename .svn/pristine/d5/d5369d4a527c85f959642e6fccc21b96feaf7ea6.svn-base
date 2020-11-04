module RailsGist
  extend self
  protected

  def self.included(base)    
    base.send :helper_method, :gist
  end

  def gist(gist_id)
    gist_snippet_url = "http://gist.github.com/#{gist_id}"
    # chomp 移除尾部的 /[\n\r]/
    return (<<-EOS).chomp
<script src="#{gist_snippet_url}.js"></script>
<noscript><a href="#{gist_snippet_url}">gist:#{gist_id}</a></noscript>
    EOS
  end
end