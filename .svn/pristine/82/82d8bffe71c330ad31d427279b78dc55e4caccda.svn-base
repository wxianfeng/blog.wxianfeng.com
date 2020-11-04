# run : ruby script/runner script/tools/update_table_chats_ip_idc.rb

require "rubygems"
require "httpclient"
require "hpricot"
require "iconv"

class String
  def to_utf8
    Iconv.iconv("UTF-8//IGNORE","GB2312//IGNORE",self).to_s
  end
end

client = HTTPClient.new

Chat.find_each do |ele|
  content = client.get_content("http://ip138.com/ips.asp?ip=#{ele.ip}")
  html = Hpricot(content)
  idc = html.search("ul[@class='ul1']>li").first.inner_html
  # "本站主数据：北京市 北京数据家科技有限公司"
  p ele.ip + " " + idc.to_utf8.match(/：(.*)$/)[1]
  ele.ip_idc = idc.to_utf8.match(/：(.*)$/)[1] || ""
  ele.save!
end




#require'iconv'

# inject truncate method to String Class
# '中国人民chinese'.truncate(5) => 中国人民ch...

# utf8_string="\344\273\254"
# puts utf8_string #在irb中输出“浠”=>乱码
# puts utf8_string.to_gbk #在irb中输出“们”=>正确输出
# 在irb输入一汉字
# gbk_string="\303\307"
# puts gbk_string #输出"们"
# p gbk_string.to_utf8 #输出"\344\273\254"
#class String
#  # NOTE: the params length is chinese length
#  def truncate(len,postfix='...')
#    l=0
#    char_array=self.unpack("U*")
#    char_array.each_with_index do |c,i|
#      l = l+ (c<127 ? 0.5 : 1)
#      if l>=len
#        return char_array[0..i].pack("U*")+(i<char_array.length-1 ? postfix : "")
#      end
#    end
#    return self
#  end
#  alias_method :tc, :truncate
#
#  def to_gbk
#    Iconv.iconv("GB2312//IGNORE","UTF-8//IGNORE",self).to_s
#  end
#  def to_utf8
#    Iconv.iconv("UTF-8//IGNORE","GB2312//IGNORE",self).to_s
#  end
#  def utf8?
#    unpack('U*') rescue return false
#    true
#  end
#end