require 'nokogiri'
require 'open-uri'
require 'thread'
require 'set'
require './MaiWriter.rb'

SLEEP_TIME_FOR_ONE_THREAD = 1
def crawl_user(id_finished, address_out, id_finished_out, thread_num, total_thread, total_user_id)
  (0..total_user_id/total_thread).each do |i|
    user_id = total_thread * i + thread_num
    if id_finished.include? user_id
      puts "user_id #{user_id} finished before"
      next
    end
    p "user_id #{user_id} start"
    begin
      sleep SLEEP_TIME_FOR_ONE_THREAD
      doc = Nokogiri::HTML(open("https://bitcointalk.org/index.php?action=profile;u=#{user_id}"))
    rescue OpenURI::HTTPError => error
      sleep 10 + Random.rand(total_thread)
      p error.io
      redo
    end
    File.open("data/#{user_id}", "w") do |file|
      file.puts doc
      file.close
    end

    name = ""
    bitcoin_addr = ""
    doc.css('#bodyarea>table>tr>td>table>tr:nth-child(2)>td:nth-child(1)>table>tr').each do |ele|
      type = ele.css('td:first-child').text
      value = ele.css('td:nth-child(2)').text
      if type.include? 'Name:'
        name = value
      end
      if type.include? 'Bitcoin address:'
        bitcoin_addr = value
      end
    end

    p "user_id #{user_id} end"

    if name != "" and bitcoin_addr != ""
      str = "#{user_id},#{name},#{bitcoin_addr}"
      puts str
      address_out.write(str)
    end
    id_finished_out.write(user_id)
  end
end

total_thread = 5
total_user_id = 1000000
thread_pool = []
address_out = MaiWriter.new("address.out", "a")

id_finished = Set.new
id_finished_filename = "id_finished.out"

if File::exist?(id_finished_filename)
  File.open(id_finished_filename, "r") do |file|
    ids = file.readlines
    ids.each do |id|
      id_finished.add(id.to_i)
    end
    file.close
  end
end


id_finished_out = MaiWriter.new(id_finished_filename, "a")

(1..total_thread).each do |thread_num|
  thread_pool[thread_num] = Thread.new{
    crawl_user(id_finished, address_out, id_finished_out, thread_num, total_thread, total_user_id)
  }
end

thread_pool.each do |t|
  if t
    t.join
  end
end
