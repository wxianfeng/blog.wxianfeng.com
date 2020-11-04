require "iconv"

class String
  def to_utf8
    Iconv.iconv("UTF-8//IGNORE","GB2312//IGNORE",self).to_s
  end
end