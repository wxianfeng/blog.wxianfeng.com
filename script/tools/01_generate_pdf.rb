#注意 http://wxianfeng.com 必须存在 a 链接 , 因为 wkhtmltopdf 可以直接对 url 抓取生成 pdf

require 'rubygems'
require 'pdfkit/source'
require 'pdfkit/pdfkit'
require 'pdfkit/middleware'
require 'pdfkit/configuration'

PDFKit.configure do |config|  
  config.wkhtmltopdf = '/usr/local/bin/wkhtmltopdf'
end

range_t = [
  ["2009-06-30","2009-12-12 23:59:59"],
  ["2009-12-12","2010-06-31 23:59:59"],
  ["2010-06-31","2010-12-12 23:59:59"]
]

path = "/usr/local/system/wxianfeng_com/public/pdfs/"
exist_files = Dir.open(path).to_a.select{|x| x != '.' &&  x!= '..' && x != '.svn' && x != 'Thumbs.db'}

range_t.each do |ele|
  next if exist_files.include?("wxianfeng.com_#{ele.first}~#{ele.last.slice(/\d+-\d+-\d+/)}.pdf")
  posts = Content.all(:conditions=>["published_at BETWEEN ? AND ?",ele.first,ele.last])
  kit , html = nil , ''
  posts.each do |i|
    p i.published_at.to_s(:db) + " " +i.title
    html << "<strong>" + i.title + "</strong><br/><br/>" + i.html(:all).gsub(/[\s\n<br\/>]([a-zA-z]+:\/\/[^\s<>"]*)/,'<a href="\1">\1</a>') + "<br/><br/><br/><br/>"
  end  
  kit = PDFKit.new(html)
  # kit.stylesheets << "#{RAILS_ROOT}/themes/lindholmen/stylesheets/main.css"
  # kit.stylesheets << "#{RAILS_ROOT}/themes/lindholmen/stylesheets/print.css"
  # kit.stylesheets << "#{RAILS_ROOT}/themes/lindholmen/stylesheets/local.css"
  kit.to_pdf
  kit.to_file path + "wxianfeng.com_#{ele.first}~#{ele.last.slice(/\d+-\d+-\d+/)}.pdf"
end