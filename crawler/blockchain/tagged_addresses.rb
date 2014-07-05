require 'wombat'

class HeadersScraper
  include Wombat::Crawler

  def initialize(offset)
    base_url("https://blockchain.info")
    path("/tags?offset=#{offset}")
    super()
  end
  tagged_addresses "css=tbody tr",  :iterator do
    tag 'css=.tag'
    addr 'css=td:first-child'
    #addr_info_link 'css=td:first-child a[href=]'
    tag_link 'css=td:nth-child(3)'
    verified 'css=td:nth-child(4) img/@src'
  end
end


def verify(res)
  res["tagged_addresses"].each do |e|
    e["verified"] = (e["verified"].include? "green") ? 1:0
  end
end

(0..10000).each do |i|
  res = HeadersScraper.new(200*i).crawl
  if res["tagged_addresses"].empty? 
    break
  else
    puts verify(res)
  end
end
