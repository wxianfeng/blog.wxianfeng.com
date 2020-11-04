class CreateTableChats < ActiveRecord::Migration
  def self.up
    create_table :chats , :options=>"engine=innodb" do |t|
      t.text :body
      t.string :ip
      t.timestamps
    end
  end

  def self.down
  end
end
