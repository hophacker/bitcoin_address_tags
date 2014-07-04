# crawler to pull tags from https://blockchain.info/tags




## Tools 
**nokogiri**: An HTML, XML, SAX, and Reader parser
* http://nokogiri.org/

**wombat**: Crawler
* https://github.com/felipecsl/wombat/

* Backup choice
    * *cobweb*: Documentation sucks.
    
**Json**: easy to write and setup, well structured

* Backup choice
    * *Mysql*: Well fit into our work

    * *Mongo*: The interface is very simple, and very easy to understand.  Information online is not structured very well, we need a flexible way to combine information from different pages. The columns are growing, ex, first, we have bitcoin address column, then the crawler gets into another page, we have the output amount of the bitcoin address. Mongodb can combine the two by simply redefine the table.


## Install: 
gem install mongo nokogiri wombat

## Run:
Currently supports Ruby 1.9.3
```bash
~$ git pull ...
~$ rvm install 1.9.3 
~$ rvm use 1.9.3 --default
~$ ruby tagged_addresses.rb > tagged_addresses.out
```
## Output format
* **addr** : bitcoin address
    *   Using https://blockchain.info/address/{addr} to access more information about this address
* **tag** : the tagged identity information for this bitcoin adress
* **tag_link** : The link for this tag
* **verified** : If this tag is verified

## Problems
Using Wombat
 can't activate json-1.8.0, already activated json-1.8.1 (Gem::LoadError)  
There’s currently a bug for this problem
https://github.com/calabash/calabash-ios/issues/388
Install Ruby 1.9.3
http://web.stanford.edu/~ouster/cgi-bin/cs142-spring13/railsInstall.php
rvm install 1.9.3 
rvm use 1.9.3 --default

## To-Do
Fix the json problem and make it more extendable

## Helpful links
