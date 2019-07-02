# HAB eXist-db OAI-PMH Interface

This is the
[OAI-PMH](https://www.openarchives.org/OAI/openarchivesprotocol.html) Interface
for the [Manuscript Database](http://diglib.hab.de/?db=mss&lang=en) by
[Herzog August Bibliothek Wolfenbüttel](http://www.hab.de/en/home.html). The 
interface is implemented as an eXist-db application which can be
[downloaded here](https://raw.githubusercontent.com/wendig-ou/hab-oai-pmh/master/dist/hab-oai-pmh-0.1.xar).

# Deployment

Just upload the .xar file to your eXist-db package manager.

TODO: xml:base attributes confusion

# Development

This repository ships with a [Vagrantfile](https://www.vagrantup.com/) so you may run

~~~bash
vagrant up
~~~

to get startet. The dataset used to develop this software is not
included and has to be installed afterwards, which is very simple: Given the
file mss.zip in /vagrant/mss.zip, do

~~~bash
vagrant ssh
cd /mnt
sudo /vagrant/bin/mount.sh # leave password empty when prompted

sudo unzip /vagrant/mss.zip
sudo cp -urv mss/ dav/ # this will take a lot of time
sudo rm -rf mss
sudo umount dav
~~~

At this point the data is available and once the application can be used at
https://localhost:8080

# Tests

The application has been validated with
[the official OAI-PMH validator](https://www.openarchives.org/Register/ValidateSite)
and there is a number of local tests available as rspec tests. To run them,
install ruby, run `bundle install` and then `bundle exec rspec`.

# XQuery and eXist-db resources

* https://www.w3.org/TR/2017/REC-xquery-31-20170321/#id-filter-expression
* https://www.ibm.com/support/knowledgecenter/en/SSEPGG_10.5.0/com.ibm.db2.luw.xml.doc/doc/xqrduration.html
* http://www.april.secac.com/website/YoungloveTEI.pdf
* https://www.tutorialspoint.com/xquery/xquery_indexof.htm
* http://www.xqueryfunctions.com/xq/fn_base-uri.html
* http://exist-db.org/exist/apps/fundocs/index.html
* https://www.w3schools.com/xml/xquery_example.asp
* https://www.w3.org/TR/xquery-operators/#general-seq-funcs
* https://www.w3.org/TR/2017/REC-xquery-31-20170321/
* http://www.existsolutions.com/contact.xml
* https://stackoverflow.com/questions/3782508/updating-variables-in-xquery-possible-or-not