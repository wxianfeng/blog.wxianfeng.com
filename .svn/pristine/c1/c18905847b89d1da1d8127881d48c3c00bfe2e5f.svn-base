# 缩放图片(width=480)
# run : ruby resize_wxianfeng_com_img.rb

require 'rubygems'
require 'mini_magick'

# path = "E:/Rubyproject/wxianfeng_com/public/files/"
path = "/usr/local/system/www/wxianfeng_com/shared/public/files/"
files = Dir.open(path).to_a.select{|x| x != '.' &&  x!= '..' && x != '.svn' && x != 'Thumbs.db'}
imgs = files.select { |f| f !~ /^(thumb_|middle_)/ }

imgs.each do |ele|
  p ele
  img_path = path + ele
  img = MiniMagick::Image.from_file(img_path)
  w,h = img[:width],img[:height] 
  percent = ((480/w.to_f) * 100).to_i
  img.combine_options do |c|
    c.sample "#{percent}%" # 缩放
  end
  img.write(img_path)
end