Enron Email Mobile Search
=========================

My take on the mobile Enron Email Search. The purpose is to achieve the fast search on the device across a very large data set without loading it into RAM. The data has to be indexed before running the code. Please, run indexer.rb , which will take the data from the "raw" folder and create or refresh the data in the index folder.

The parser is in ruby, the mobile search is in c++, the mobile UI is obj-c

Please, note, that the parser and the mobile code has been tested on the subset of data only. There may be performance or memory related surprises if tested with the real data, and further tweaks to the code needed.

You can download the full enron email database here:
http://www.cs.cmu.edu/~enron/enron_mail_20110402.tgz

![ScreenShot](https://github.com/radif/enron-email-mobile-search/master/screenshot.png)