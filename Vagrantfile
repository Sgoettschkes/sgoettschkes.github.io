# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "Sgoettschkes/debian7"

  config.vm.network "forwarded_port", guest: 4000, host: 4000

  # Put ssh key inside vm
  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "/home/vagrant/.ssh/id_rsa"
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
  config.vm.provision "shell", inline: "chmod 0600 /home/vagrant/.ssh/id_rsa*"

  # install jekyll and dependencies
  config.vm.provision "shell", inline: "apt-get update"
  config.vm.provision "shell", inline: "gem install --no-rdoc --no-ri bundler jekyll rake"
  config.vm.provision "shell", inline: "apt-get install -t testing -y nodejs"
end
