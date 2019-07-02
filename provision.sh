apt-get install -y \
  openjdk-8-jre net-tools xserver-xorg davfs2 zip

cd /var
wget -q -O exist.tar.bz2 'https://bintray.com/existdb/releases/download_file?file_path=eXist-db-4.6.1.tar.bz2'
tar xjf exist.tar.bz2
mv eXist-db-4.6.1 exist
rm exist.tar.bz2

sed -i 's/<Set name="host"><Property name="jetty.http.host" deprecated="jetty.host" \/><\/Set>/<Set name="host">10.0.2.15<\/Set>/' /var/exist/tools/jetty/etc/jetty-http.xml

cp /vagrant/spec/exist.service /etc/systemd/system/exist.service
systemctl enable exist.service
systemctl start exist.service
