class MashupsController < ContentController
  layout :theme_layout , :only => [:pdf]

  def flickr
  end

  def pdf    
  end

  def download_pdf
    path = "#{RAILS_ROOT}/public/pdfs/"
    case params[:id]
    when /2009_second/
      send_file path+ "wxianfeng.com_2009-06-30~2009-12-12.pdf"
    when /2010_first/
      send_file path + "wxianfeng.com_2009-12-12~2010-06-31.pdf"
    when /2010_second/
    end
  end

end
