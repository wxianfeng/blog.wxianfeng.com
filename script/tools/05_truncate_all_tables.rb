# 清空mysql所有表的数据
# run: ruby truncate_all_tables.rb

require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "localhost",
  :database => "wxianfeng_com_dev",
  :encoding => "utf8",
  :username => "root",
  :password => "root"
)

begin
  ActiveRecord::Base.connection.tables.each do |table|
    p "TRUNCATEing #{table}"
    ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
  end
rescue
  $stderr.puts "Ooops Error"
end
