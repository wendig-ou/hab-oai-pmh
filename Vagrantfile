Vagrant.configure("2") do |c|
  c.vagrant.plugins = ['vagrant-vbguest']

  c.vm.box = 'debian/stretch64'
  c.vm.box_version = '9.6.0'
  c.vm.hostname = 'hab-oai-pmh'

  c.vm.synced_folder '.', '/vagrant', type: 'virtualbox'

  c.vm.network :forwarded_port, host: 8080, guest: 8080, host_ip: '127.0.0.1'
  c.vm.network :forwarded_port, host: 8443, guest: 8443, host_ip: '127.0.0.1'

  c.vm.provider :virtualbox do |vb|
    vb.name = 'hab-oai-pmh'
    vb.memory = 2024
    vb.cpus = 2
  end

  c.vm.provision :shell, path: 'provision.sh'
end
