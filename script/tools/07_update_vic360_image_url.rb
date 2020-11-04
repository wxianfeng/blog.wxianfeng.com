#!/usr/bin/env ruby
# 修改 www.vic360.com中图片链接错误问题
# localhost/~w/projects/vic360 => www.vic360.com
# http://stackoverflow.com/questions/2693862/how-do-i-require-a-specific-version-of-a-ruby-gem

# TIP:
#localhost:wxianfeng_com wangxianfeng$ ruby script/tools/07_update_vic360_image_url.rb
#/Users/wangxianfeng/.rvm/gems/ruby-1.9.2-p290/gems/activerecord-3.0.3/lib/active_record/relation/batches.rb:68:in `find_in_batches': undefined method `gteq' for nil:NilClass (NoMethodError)
#	from /Users/wangxianfeng/.rvm/gems/ruby-1.9.2-p290/gems/activerecord-3.0.3/lib/active_record/relation/batches.rb:20:in `find_each'
#	from /Users/wangxianfeng/.rvm/gems/ruby-1.9.2-p290/gems/activerecord-3.0.3/lib/active_record/base.rb:440:in `find_each'
#	from script/tools/07_update_vic360_image_url.rb:23:in `<main>'

# 需要使用 set_primary_key, 默认的是id

require 'rubygems'
gem 'activerecord', '=3.0.3' # gem指定版本
require 'active_record'
gem 'mysql2','=0.2.6'
require 'mysql2'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql2",
  :host => "localhost",
  :database => "vic360",
  :encoding => "utf8",
  :username => "root",
  :password => "root"
)

class Vic360Post < ActiveRecord::Base
  set_primary_key "ID"
end

Vic360Post.find_each do |post|
  p post.ID
  content = post.post_content
  post.post_content = content.gsub(/localhost\/~w\/projects\/vic360/,'www.vic360.com')
  post.save
end