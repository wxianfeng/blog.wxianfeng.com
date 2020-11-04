class DemosController < ContentController  
  layout :theme_layout ,:only=>['index']
  
  def index
    @demos = []
    @demos << ['jquery_calendar',"/demos/calendar"]
    @demos << ['contentSlider',"/demos/contentslider"]
    @demos << ['juggernaut_chat',"/demos/chat_jquery"]
    @page_title = "Demos"
  end

  def calendar ;  end
  def contentslider ; end
  def chat_prototype ;   end
  def chat_jquery
    @chats = Chat.all(:order=>"created_at DESC")
  end

  # prototype
  def send_data_p
    render :juggernaut do |page|
      page.insert_html :top, 'chat_data', "<li>#{h params[:chat_input]}</li>"
    end
    render :nothing => true
  end

  # jQuery
  def send_data_j
    body = params[:chat_input]
    ip = request.headers['x-real-ip']
    ip = request.remote_ip if ip.nil?    
    client = HTTPClient.new
    # SEE : http://www.hostip.info/use.html
    content = client.get_content("http://api.hostip.info/get_html.php?ip=#{ip}&position=true")
    idc_content = client.get_content("http://ip138.com/ips.asp?ip=#{ip}")
    html = Hpricot(idc_content)
    idc = html.search("ul[@class='ul1']>li").first.inner_html
    ip_idc = idc.to_utf8.match(/：(.*)$/)[1] || ""
    arr = content.scan(/.*\n/)
    ip_country = arr[0].match(/:(.*)/)[1].strip
    ip_city = arr[1].match(/:(.*)/)[1].strip
    ip_latitude = arr[3].match(/:(.*)/)[1].strip
    ip_longitude = arr[4].match(/:(.*)/)[1].strip
    Chat.create({
      :body => body,
      :ip => ip,
      :ip_country => ip_country,
      :ip_city => ip_city,
      :ip_latitude => ip_latitude,
      :ip_longitude => ip_longitude,
      :ip_idc => ip_idc
      })
    render :juggernaut do |page|
      # page["#chat_input"].val("")
      page["#chat_data"].prepend "<li>#{Time.now().to_s(:db)} --- <span style='color:#CC0000;'>#{body}</span> --- #{ip}<span style='font-size:11px;'>#{ip_country} #{ip_city} #{ip_idc} </span></li>"
      # page["#titl"].Text = "wang"
      page["#updatetitle"].click()      
    end
    render :nothing => true
  end

  def test
    #render :text => gist(784576) # 2056
  end

  def mark_spam
    comment = Feedback.find params[:id]
    comment.published = false
    if comment.save
      redirect_to :back and return
    else
      render :text => "Oops, ERROR"
    end
  end

end
